import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';
import '../../../core/utils/singapore_time.dart';
import '../../../core/widgets/dex_google_map.dart';
import '../domain/donation_centre.dart';

class CentreDetailPage extends ConsumerWidget {
  final String centreId;

  const CentreDetailPage({
    super.key,
    required this.centreId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centre Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareCentre(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(centresRepositoryProvider).getCentreById(centreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, snapshot.error.toString());
          }

          final centre = snapshot.data;
          if (centre == null) {
            return _buildNotFoundState(context);
          }

          return _buildCentreContent(context, centre);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => context.push('/centres/$centreId/book'),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Book Group Appointment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
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
          const Text('Error loading centre details'),
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
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Centre not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildCentreContent(BuildContext context, dynamic centre) {
    try {
      return SingleChildScrollView(
        child: Column(
          children: [
            // Google Maps Integration
            Container(
              height: 250,
              width: double.infinity,
              child: centre.lat != null && centre.lng != null
                  ? _buildGoogleMap(context, centre)
                  : _buildNoMapPlaceholder(),
            ),
            
            // Centre Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header info
                  _buildHeaderInfo(centre),
                  
                  const SizedBox(height: 24),
                  
                  // Contact & Location
                  _buildContactSection(context, centre),
                  
                  const SizedBox(height: 24),
                  
                  // Opening Hours
                  _buildOpeningHoursSection(centre),
                  
                  const SizedBox(height: 24),
                  
                  // Getting Here
                  _buildGettingHereSection(centre),
                  
                  const SizedBox(height: 24),
                  
                  // Additional Info
                  _buildAdditionalInfoSection(centre),
                  
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // If there's a critical error, show error page
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load centre details. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Refresh the page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CentreDetailPage(centreId: centreId),
                  ),
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildGoogleMap(BuildContext context, dynamic centre) {
    return DexGoogleMap(
      latitude: centre.lat!,
      longitude: centre.lng!,
      centreName: centre.name,
      centreAddress: centre.address,
      onDirectionsPressed: () => _openInMaps(context, centre),
      height: 250,
      showControls: true,
    );
  }

  Widget _buildNoMapPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Location not available'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(dynamic centre) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          centre.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: centre.type == 'Blood Bank' 
                    ? DexterTokens.dexLeaf.withOpacity(0.1)
                    : DexterTokens.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                centre.type,
                style: TextStyle(
                  color: centre.type == 'Blood Bank' 
                      ? DexterTokens.dexLeaf
                      : DexterTokens.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildOpenStatus(centre),
          ],
        ),
      ],
    );
  }

  Widget _buildOpenStatus(dynamic centre) {
    try {
      final isOpen = SingaporeTime.isCurrentlyOpen(centre.donationTypes['wholeBlood']['openingHours']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen 
            ? DexterTokens.dexBlood.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOpen ? DexterTokens.dexBlood : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: TextStyle(
              color: isOpen ? DexterTokens.dexBlood : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    } catch (e) {
      // If there's an error with donation types, return closed status
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Closed',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildContactSection(BuildContext context, dynamic centre) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact & Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Address
            _buildContactItem(
              Icons.location_on,
              'Address',
              centre.address,
              () => _openInMaps(context, centre),
            ),
            
            // Phone
            if (centre.phone != null) ...[
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.phone,
                'Phone',
                centre.phone!,
                () => _callPhone(centre.phone!),
              ),
            ],
            
            // Booking URL
            if (centre.bookingUrl != null) ...[
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.web,
                'Website',
                'Visit HSA Website',
                () => _openUrl(centre.bookingUrl!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: DexterTokens.dexGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHoursSection(dynamic centre) {
    try {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opening Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Whole Blood Donation Section
              _buildDonationTypeSection(
                centre,
                'Whole blood donation',
                centre.donationTypes['wholeBlood'],
              ),
              
              const SizedBox(height: 20),
              
              // Apheresis Donation Section (if available)
              if (centre.donationTypes['apheresis']?['available'] == true)
                _buildDonationTypeSection(
                  centre,
                  'Apheresis donation',
                  centre.donationTypes['apheresis'],
                ),
              
              // Apheresis Not Available Note
              if (centre.donationTypes['apheresis']?['available'] == false)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          centre.donationTypes['apheresis']?['note'] ?? 'Apheresis donation is not available at this location',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              // Additional Notes
              if (centre.notes != null && centre.notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Note: ${centre.notes.join(' ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } catch (e) {
      // If there's an error with opening hours, return error card
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opening Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Unable to load opening hours. Please try again later.',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDonationTypeSection(dynamic centre, String title, Map<String, dynamic> donationType) {
    try {
      if (donationType['available'] != true) {
        return const SizedBox.shrink();
      }

      final openingHours = donationType['openingHours'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: DexterTokens.dexGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: DexterTokens.dexGreen.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DexterTokens.dexGreen,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Opening Hours for each day
        ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
          final hours = openingHours.containsKey(day) ? openingHours[day] : <dynamic>[];
          final isToday = day == SingaporeTime.getCurrentDay();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 90, // Increased width to accommodate "Public Holiday" and align all rows
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? DexterTokens.dexGreen : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    SingaporeTime.formatDayHours(hours),
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? DexterTokens.dexGreen : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        
        // Public Holiday row
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 90, // Same width as other days for perfect alignment
                child: Text(
                  'Public Holiday',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Closed',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Special Hours (if available)
        if (donationType['specialHours'] != null) ...[
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Special Hours',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          ...((donationType['specialHours'] as Map<String, dynamic>).entries.map((entry) {
            String displayName = entry.key;
            if (entry.key == 'newYearEve') displayName = 'New Year Eve';
            if (entry.key == 'chineseNewYearEve') displayName = 'Chinese New Year Eve';
            if (entry.key == 'christmasEve') displayName = 'Christmas Eve';
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          })),
        ],
      ],
    );
    } catch (e) {
      // If there's an error with donation type data, return empty section
      return const SizedBox.shrink();
    }
  }

  Widget _buildGettingHereSection(dynamic centre) {
    if (centre.transportation == null) {
      return const SizedBox.shrink();
    }

    try {
      final transportation = centre.transportation as Map<String, dynamic>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Getting Here',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // MRT Information
            if (transportation['mrt'] != null) ...[
              _buildTransportItem(
                icon: Icons.train,
                title: 'MRT',
                content: _buildMRTInfo(transportation['mrt']),
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
            ],

            // LRT Information
            if (transportation['lrt'] != null) ...[
              _buildTransportItem(
                icon: Icons.tram,
                title: 'LRT',
                content: _buildLRTInfo(transportation['lrt']),
                color: Colors.green,
              ),
              const SizedBox(height: 16),
            ],

            // Bus Information
            if (transportation['bus'] != null) ...[
              _buildTransportItem(
                icon: Icons.directions_bus,
                title: 'Bus',
                content: _buildBusInfo(transportation['bus']),
                color: Colors.red,
              ),
            ],
          ],
        ),
      ),
    );
    } catch (e) {
      // If there's an error with transportation data, return empty section
      return const SizedBox.shrink();
    }
  }

  Widget _buildTransportItem({
    required IconData icon,
    required String title,
    required Widget content,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMRTInfo(Map<String, dynamic> mrtInfo) {
    final station = mrtInfo['station'] as String?;
    final lines = mrtInfo['lines'] as List<dynamic>?;
    final exits = mrtInfo['exits']; // Don't cast yet, check type first
    final directions = mrtInfo['directions'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (station != null) ...[
          Text(
            station,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (lines != null && lines.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            children: lines.map((line) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getMRTLineColor(line),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                line,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
        ],
        if (exits != null && exits.isNotEmpty) ...[
          Text(
            exits is Map ? 'Exits: ${(exits as Map<String, dynamic>).values.join(', ')}' : 'Exits: ${(exits as List<dynamic>).join(', ')}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (directions != null) ...[
          Text(
            directions,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLRTInfo(Map<String, dynamic> lrtInfo) {
    final station = lrtInfo['station'] as String?;
    final lines = lrtInfo['lines'] as List<dynamic>?;
    final exits = lrtInfo['exits']; // Don't cast yet, check type first
    final directions = lrtInfo['directions'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (station != null) ...[
          Text(
            station,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (lines != null && lines.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            children: lines.map((line) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                line,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
        ],
        if (exits != null && exits.isNotEmpty) ...[
          Text(
            exits is Map ? 'Exits: ${(exits as Map<String, dynamic>).values.join(', ')}' : 'Exits: ${(exits as List<dynamic>).join(', ')}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (directions != null) ...[
          Text(
            directions,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBusInfo(Map<String, dynamic> busInfo) {
    try {
      final services = busInfo['services'] as List<dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (services != null && services.isNotEmpty) ...[
          Text(
            'Bus Services:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            children: services.map((service) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Text(
                service.toString(),
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ],
    );
    } catch (e) {
      // If there's an error with bus data, return empty section
      return const SizedBox.shrink();
    }
  }

  Color _getMRTLineColor(String line) {
    switch (line) {
      case 'NS':
        return Colors.red;
      case 'EW':
        return Colors.green;
      case 'CC':
        return Colors.yellow[700]!;
      case 'DT':
        return Colors.blue;
      case 'TE':
        return Colors.brown;
      case 'NE':
        return Colors.purple;
      case 'TEL':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAdditionalInfoSection(dynamic centre) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              '• Bring a valid ID (NRIC, passport, or driving licence)\n'
              '• Eat a proper meal before donating\n'
              '• Stay hydrated by drinking plenty of water\n'
              '• Avoid alcohol 24 hours before donation\n'
              '• Get adequate rest the night before',
              style: TextStyle(height: 1.5),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: DexterTokens.dexLeaf),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For first-time donors or if you have medical conditions, please consult with the medical staff on-site.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods


  void _shareCentre(BuildContext context) {
    // TODO: Implement sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing feature coming soon!')),
    );
  }

  void _openInMaps(BuildContext context, dynamic centre) async {
    if (centre.lat != null && centre.lng != null) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${centre.lat},${centre.lng}&destination_place_id=${Uri.encodeComponent(centre.name)}';
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps for ${centre.name}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location coordinates not available for ${centre.name}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _callPhone(String phone) async {
    // TODO: Implement phone dialing
    print('Calling phone: $phone');
  }

  void _openUrl(String url) async {
    // TODO: Implement URL opening
    print('Opening URL: $url');
  }
}
