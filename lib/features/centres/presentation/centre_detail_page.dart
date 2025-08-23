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
                
                // Additional Info
                _buildAdditionalInfoSection(centre),
                
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
    );
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
    // Debug: Test the opening hours logic
    SingaporeTime.testOpeningHours(centre.openingHours);
    
    final isOpen = SingaporeTime.isCurrentlyOpen(centre.openingHours);

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
            
            ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
              final hours = centre.openingHours.containsKey(day) ? centre.openingHours[day] : <OpeningHours>[];
              final isToday = day == SingaporeTime.getCurrentDay();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
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
                        SingaporeTime.formatTodaysHours({day: hours}),
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
          ],
        ),
      ),
    );
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
