import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class BookingCreatePage extends ConsumerStatefulWidget {
  final String centreId;

  const BookingCreatePage({
    super.key,
    required this.centreId,
  });

  @override
  ConsumerState<BookingCreatePage> createState() => _BookingCreatePageState();
}

class _BookingCreatePageState extends ConsumerState<BookingCreatePage> {
  String? _selectedDonationType; // 'wholeBlood' or 'apheresis'
  DateTime? _selectedDate;
  String? _selectedTime;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(dynamic centre) async {
    if (_selectedDonationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a donation type first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final firstDate = now;
    final lastDate = now.add(const Duration(days: 90));

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime day) {
        return _isDayAvailable(day, centre);
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedTime = null; // Reset time when date changes
      });
    }
  }

  bool _isDayAvailable(DateTime day, dynamic centre) {
    if (_selectedDonationType == null) return false;
    
    final dayOfWeek = _getDayOfWeek(day.weekday);
    final dayHours = centre.donationTypes[_selectedDonationType]['openingHours'][dayOfWeek] as List<dynamic>?;
    
    return dayHours != null && dayHours.isNotEmpty;
  }

  Future<void> _createBooking() async {
    if (_selectedDonationType == null || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select donation type, date and time'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authStateProvider);
      final currentUser = authState.value;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final bookingRepository = ref.read(bookingRepositoryProvider);
      final booking = await bookingRepository.createGroupBooking(
        centreId: widget.centreId,
        date: _selectedDate!,
        startTime: _selectedTime!,
        createdByUid: currentUser.uid,
        notes: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
      );

      // Schedule notifications
      final notificationService = ref.read(localNotificationsProvider);
      final centre = await ref.read(centresRepositoryProvider).getCentreById(widget.centreId);
      
      if (centre != null) {
        final bookingDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          int.parse(_selectedTime!.split(':')[0]),
          int.parse(_selectedTime!.split(':')[1]),
        );

        await notificationService.scheduleBookingReminders(
          bookingId: booking.id,
          bookingDateTime: bookingDateTime,
          centreName: centre.name,
        );
      }

      if (mounted) {
        _showSuccessDialog(booking);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating booking: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(dynamic booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: DexterTokens.dexBlood),
            SizedBox(width: 8),
            Text('Booking Created!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 64,
              color: DexterTokens.dexGreen,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your group booking has been created successfully!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${_formatDate(_selectedDate!)}\nTime: $_selectedTime',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addToCalendar(booking);
            },
            child: const Text('Add to Calendar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/bookings');
            },
            child: const Text('View Bookings'),
          ),
        ],
      ),
    );
  }

  void _addToCalendar(dynamic booking) async {
    try {
      final centre = await ref.read(centresRepositoryProvider).getCentreById(widget.centreId);
      
      if (centre == null) return;

      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        int.parse(_selectedTime!.split(':')[0]),
        int.parse(_selectedTime!.split(':')[1]),
      );

      final endDateTime = startDateTime.add(const Duration(hours: 1));

      final Event event = Event(
        title: 'Blood Donation - ${centre.name}',
        description: 'Group blood donation appointment\n\n${centre.address}',
        location: centre.address,
        startDate: startDateTime,
        endDate: endDateTime,
        iosParams: const IOSParams(
          reminder: Duration(hours: 2),
        ),
        androidParams: const AndroidParams(
          emailInvites: [],
        ),
      );

      await Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to calendar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Group Appointment'),
      ),
      body: FutureBuilder(
        future: ref.read(centresRepositoryProvider).getCentreById(widget.centreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error loading centre information'),
            );
          }

          final centre = snapshot.data!;
          return _buildBookingForm(centre);
        },
      ),
    );
  }

  Widget _buildBookingForm(dynamic centre) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Centre Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    centre.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    centre.address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Donation Type Selection
          _buildDonationTypeSelector(centre),
          
          const SizedBox(height: 16),
          
          // Date Selection
          _buildDateSelector(centre),
          
          const SizedBox(height: 16),
          
          // Time Selection
          if (_selectedDonationType != null && _selectedDate != null)
            _buildTimeSelector(centre),
          
          const SizedBox(height: 16),
          
          // Notes
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Any special requirements or notes...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          
          const SizedBox(height: 24),
          
          // Guidelines
          Card(
            color: Colors.blue[50],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: DexterTokens.dexLeaf),
                      SizedBox(width: 8),
                      Text(
                        'Booking Guidelines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: DexterTokens.dexLeaf,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Arrive 15 minutes before your scheduled time\n'
                    '• Bring valid identification\n'
                    '• Eat a proper meal before donation\n'
                    '• You can invite friends via the share function',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Create Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _createBooking,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Group Booking'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTypeSelector(dynamic centre) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Donation Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Whole Blood Option
            if (centre.donationTypes['wholeBlood']?['available'] == true)
              _buildDonationTypeOption(
                'wholeBlood',
                'Whole Blood Donation',
                'Regular blood donation including red blood cells, white blood cells, platelets and plasma',
                Icons.favorite,
                Colors.red,
              ),
            
            const SizedBox(height: 12),
            
            // Apheresis Option
            if (centre.donationTypes['apheresis']?['available'] == true)
              _buildDonationTypeOption(
                'apheresis',
                'Apheresis Donation',
                'Targeted donation of specific blood components like platelets or plasma',
                Icons.science,
                Colors.blue,
              )
            else
              _buildUnavailableDonationTypeOption(
                'Apheresis Donation',
                centre.donationTypes['apheresis']?['note'] ?? 'Apheresis donation is not available at this location',
                Icons.science,
                Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationTypeOption(
    String typeKey,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedDonationType == typeKey;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDonationType = typeKey;
          _selectedDate = null; // Reset date when donation type changes
          _selectedTime = null; // Reset time when donation type changes
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? DexterTokens.dexGreen : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? DexterTokens.dexGreen.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? DexterTokens.dexGreen : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: DexterTokens.dexGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableDonationTypeOption(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.block,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(dynamic centre) {
    final isEnabled = _selectedDonationType != null;
    
    return Card(
      child: InkWell(
        onTap: isEnabled ? () => _selectDate(centre) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today, 
                color: isEnabled ? DexterTokens.dexGreen : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : isEnabled 
                              ? 'Choose a date for your appointment'
                              : 'Select donation type first',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isEnabled ? Colors.black54 : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(dynamic centre) {
    if (_selectedDonationType == null) {
      return const SizedBox.shrink();
    }
    
    final dayOfWeek = _getDayOfWeek(_selectedDate!.weekday);
    final dayHours = centre.donationTypes[_selectedDonationType]['openingHours'][dayOfWeek] as List<dynamic>?;

    if (dayHours == null || dayHours.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.schedule_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Centre is closed on ${_formatDate(_selectedDate!)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Generate time slots
    final timeSlots = _generateTimeSlots(dayHours);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? DexterTokens.dexGreen 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _generateTimeSlots(List<dynamic> dayHours) {
    final slots = <String>[];
    
    for (final period in dayHours) {
      final startTime = period['start'] as String;
      final endTime = period['end'] as String;
      
      final startMinutes = _timeToMinutes(startTime);
      final endMinutes = _timeToMinutes(endTime);
      
      // Generate 30-minute slots
      for (int minutes = startMinutes; 
           minutes < endMinutes; 
           minutes += 30) {
        slots.add(_minutesToTime(minutes));
      }
    }
    
    return slots;
  }

  String _getDayOfWeek(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String _minutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}
