import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class BookingDetailPage extends ConsumerWidget {
  final String bookingId;

  const BookingDetailPage({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareBooking(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(bookingRepositoryProvider).getBookingById(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, snapshot.error.toString());
          }

          final booking = snapshot.data;
          if (booking == null) {
            return _buildNotFoundState(context);
          }

          return _buildBookingContent(context, ref, booking);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Error loading booking'),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_view_day, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Booking not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingContent(BuildContext context, WidgetRef ref, dynamic booking) {
    final isUpcoming = booking.date.isAfter(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Status Card
          _buildStatusCard(booking, isUpcoming),
          
          const SizedBox(height: 20),
          
          // Centre Information
          _buildCentreCard(context, ref, booking.centreId),
          
          const SizedBox(height: 20),
          
          // Date & Time
          _buildDateTimeCard(booking),
          
          const SizedBox(height: 20),
          
          // Attendees & RSVP
          _buildAttendeesCard(context, ref, booking),
          
          const SizedBox(height: 20),
          
          // Notes
          if (booking.notes != null && booking.notes!.isNotEmpty)
            _buildNotesCard(booking),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          if (isUpcoming)
            _buildActionButtons(context, ref, booking),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatusCard(dynamic booking, bool isUpcoming) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUpcoming
                    ? DexterTokens.dexBlood.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUpcoming ? Icons.schedule : Icons.history,
                color: isUpcoming ? DexterTokens.dexBlood : Colors.grey[600],
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUpcoming ? 'Upcoming Appointment' : 'Past Appointment',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created ${_formatDate(booking.createdAt)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentreCard(BuildContext context, WidgetRef ref, String centreId) {
    return Card(
      child: FutureBuilder(
        future: ref.read(centresRepositoryProvider).getCentreById(centreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final centre = snapshot.data;
          if (centre == null) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Centre information not available'),
            );
          }

          return InkWell(
            onTap: () => context.push('/centres/${centre.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: DexterTokens.dexGreen),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          centre.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          centre.address,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeCard(dynamic booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: DexterTokens.dexGreen),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatDate(booking.date),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: DexterTokens.dexGreen),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            booking.startTime,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeesCard(BuildContext context, WidgetRef ref, dynamic booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attendees',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: DexterTokens.dexGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${booking.attendees.length} total',
                    style: const TextStyle(
                      color: DexterTokens.dexGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // RSVP Summary
            Row(
              children: [
                _buildRsvpSummaryItem('Confirmed', _getRsvpCount(booking.rsvps, 'yes'), DexterTokens.dexBlood),
                const SizedBox(width: 16),
                _buildRsvpSummaryItem('Maybe', _getRsvpCount(booking.rsvps, 'maybe'), DexterTokens.warning),
                const SizedBox(width: 16),
                _buildRsvpSummaryItem('Declined', _getRsvpCount(booking.rsvps, 'no'), Colors.red),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Attendee List
            ...booking.attendees.map<Widget>((uid) {
              return _buildAttendeeItem(ref, uid, booking.rsvps[uid]);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRsvpSummaryItem(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$count $label',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAttendeeItem(WidgetRef ref, String uid, String? rsvpStatus) {
    return FutureBuilder(
      future: ref.read(authRepositoryProvider).getUserProfile(uid),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final userName = user?.displayName ?? 'User';
        
        IconData statusIcon;
        Color statusColor;
        
        switch (rsvpStatus) {
          case 'yes':
            statusIcon = Icons.check_circle;
            statusColor = DexterTokens.dexBlood;
            break;
          case 'no':
            statusIcon = Icons.cancel;
            statusColor = Colors.red;
            break;
          case 'maybe':
            statusIcon = Icons.help;
            statusColor = DexterTokens.warning;
            break;
          default:
            statusIcon = Icons.hourglass_empty;
            statusColor = Colors.grey;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: DexterTokens.dexGreen.withOpacity(0.1),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: DexterTokens.dexGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Icon(statusIcon, color: statusColor, size: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesCard(dynamic booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              booking.notes!,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, dynamic booking) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addToCalendar(context, ref, booking),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Add to Calendar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _shareBooking(context),
                icon: const Icon(Icons.share),
                label: const Text('Invite Friends'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _updateRsvp(context, ref, booking),
            icon: const Icon(Icons.edit),
            label: const Text('Update RSVP'),
            style: OutlinedButton.styleFrom(
              foregroundColor: DexterTokens.dexLeaf,
              side: const BorderSide(color: DexterTokens.dexLeaf),
            ),
          ),
        ),
      ],
    );
  }

  void _addToCalendar(BuildContext context, WidgetRef ref, dynamic booking) async {
    try {
      final centre = await ref.read(centresRepositoryProvider).getCentreById(booking.centreId);
      
      if (centre == null) return;

      final startDateTime = DateTime(
        booking.date.year,
        booking.date.month,
        booking.date.day,
        int.parse(booking.startTime.split(':')[0]),
        int.parse(booking.startTime.split(':')[1]),
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
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event added to calendar'),
            backgroundColor: DexterTokens.dexBlood,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to calendar: $e')),
        );
      }
    }
  }

  void _shareBooking(BuildContext context) {
    // TODO: Implement booking sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _updateRsvp(BuildContext context, WidgetRef ref, dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => _RsvpDialog(
        bookingId: booking.id,
        currentRsvp: booking.rsvps[ref.read(authStateProvider).value?.uid] ?? 'maybe',
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  int _getRsvpCount(Map<String, String> rsvps, String status) {
    return rsvps.values.where((rsvp) => rsvp == status).length;
  }
}

class _RsvpDialog extends ConsumerStatefulWidget {
  final String bookingId;
  final String currentRsvp;

  const _RsvpDialog({
    required this.bookingId,
    required this.currentRsvp,
  });

  @override
  ConsumerState<_RsvpDialog> createState() => _RsvpDialogState();
}

class _RsvpDialogState extends ConsumerState<_RsvpDialog> {
  late String _selectedRsvp;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRsvp = widget.currentRsvp;
  }

  Future<void> _updateRsvp() async {
    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authStateProvider);
      final currentUser = authState.value;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await ref.read(bookingRepositoryProvider).updateRSVP(
        bookingId: widget.bookingId,
        uid: currentUser.uid,
        rsvpStatus: _selectedRsvp,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('RSVP updated successfully'),
            backgroundColor: DexterTokens.dexBlood,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating RSVP: $e'),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update RSVP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Yes, I\'ll attend'),
            value: 'yes',
            groupValue: _selectedRsvp,
            onChanged: (value) {
              setState(() {
                _selectedRsvp = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Maybe'),
            value: 'maybe',
            groupValue: _selectedRsvp,
            onChanged: (value) {
              setState(() {
                _selectedRsvp = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('No, I can\'t attend'),
            value: 'no',
            groupValue: _selectedRsvp,
            onChanged: (value) {
              setState(() {
                _selectedRsvp = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateRsvp,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }
}
