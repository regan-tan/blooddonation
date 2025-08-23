import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class MyBookingsPage extends ConsumerWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: DexterTokens.dexInk,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.98),
        elevation: 2,
        shadowColor: DexterTokens.dexGreen.withOpacity(0.1),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myBookingsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(context, ref, booking);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, ref, error.toString()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    DexterTokens.dexGreen.withOpacity(0.1),
                    DexterTokens.dexLeaf.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
                border: Border.all(
                  color: DexterTokens.dexGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: DexterTokens.dexGreen.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DexterTokens.dexInk,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: DexterTokens.dexIvory.withOpacity(0.3),
                borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
              ),
              child: Text(
                'Book your first group appointment to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: DexterTokens.dexInk.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/centres'),
              icon: const Icon(Icons.location_on),
              label: const Text('Find Centres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DexterTokens.dexGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    // Check if it's a Firestore index error
    final isIndexError = error.contains('index') || error.contains('failed-precondition');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isIndexError ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
                border: Border.all(
                  color: isIndexError ? Colors.orange.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                isIndexError ? Icons.warning_amber : Icons.error_outline,
                size: 64,
                color: isIndexError ? Colors.orange : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isIndexError ? 'Database Setup Required' : 'Error Loading Bookings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: DexterTokens.dexInk,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DexterTokens.dexIvory.withOpacity(0.3),
                borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
                border: Border.all(
                  color: DexterTokens.dexLeaf.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                isIndexError 
                    ? 'We\'re setting up the database for your bookings. This will be ready shortly!'
                    : 'We encountered an issue while loading your bookings. Please try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: DexterTokens.dexInk.withOpacity(0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(myBookingsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DexterTokens.dexGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/centres'),
                  icon: const Icon(Icons.location_on),
                  label: const Text('Find Centres'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DexterTokens.dexLeaf,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, WidgetRef ref, dynamic booking) {
    final isUpcoming = booking.date.isAfter(DateTime.now());
    final isPast = booking.date.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/bookings/${booking.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? DexterTokens.dexBlood.withOpacity(0.1)
                          : isPast
                              ? Colors.grey.withOpacity(0.1)
                              : DexterTokens.dexGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isUpcoming
                          ? Icons.schedule
                          : isPast
                              ? Icons.history
                              : Icons.today,
                      color: isUpcoming
                          ? DexterTokens.dexBlood
                          : isPast
                              ? Colors.grey[600]
                              : DexterTokens.dexGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: ref.read(centresRepositoryProvider).getCentreById(booking.centreId),
                          builder: (context, snapshot) {
                            final centre = snapshot.data;
                            return Text(
                              centre?.name ?? 'Loading...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isUpcoming
                                ? DexterTokens.dexBlood.withOpacity(0.1)
                                : isPast
                                    ? Colors.grey.withOpacity(0.1)
                                    : DexterTokens.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isUpcoming
                                ? 'Upcoming'
                                : isPast
                                    ? 'Past'
                                    : 'Today',
                            style: TextStyle(
                              fontSize: 12,
                              color: isUpcoming
                                  ? DexterTokens.dexBlood
                                  : isPast
                                      ? Colors.grey[600]
                                      : DexterTokens.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Date and Time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(booking.date),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    booking.startTime,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Attendees info
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.attendees.length} attendee${booking.attendees.length != 1 ? 's' : ''}',
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${_getConfirmedCount(booking.rsvps)} confirmed',
                  ),
                ],
              ),
              
              // Notes if any
              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking.notes!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Action buttons
              if (isUpcoming) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareBooking(context, booking),
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Invite Friends'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/bookings/${booking.id}'),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/bookings/${booking.id}'),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
                ),
              ],
            ],
          ),
        ),
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

  int _getConfirmedCount(Map<String, String> rsvps) {
    return rsvps.values.where((rsvp) => rsvp == 'yes').length;
  }

  void _shareBooking(BuildContext context, dynamic booking) {
    // TODO: Implement booking sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }
}
