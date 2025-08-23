import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class ChallengeDetailPage extends ConsumerWidget {
  final String challengeId;

  const ChallengeDetailPage({
    super.key,
    required this.challengeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareChallenge(context, ref),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(bloodlineRepositoryProvider).getChallengeById(challengeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final challenge = snapshot.data;
          if (challenge == null) {
            return const Center(
              child: Text('Challenge not found'),
            );
          }

          return _buildChallengeContent(context, ref, challenge);
        },
      ),
    );
  }

  Widget _buildChallengeContent(
    BuildContext context,
    WidgetRef ref,
    dynamic challenge,
  ) {
    final streakService = ref.read(streakServiceProvider);
    final streakStatus = streakService.getStreakStatus(challenge);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Streak Status Card
          _buildStreakCard(context, streakStatus),
          
          const SizedBox(height: 20),
          
          // Challenge Progress
          _buildProgressCard(context, challenge, streakStatus),
          
          const SizedBox(height: 20),
          
          // Actions
          _buildActionsCard(context, ref, challenge),
          
          const SizedBox(height: 20),
          
          // Nominations
          _buildNominationsCard(context, ref, challenge.id),
          
          const SizedBox(height: 20),
          
          // Challenge Statistics
          _buildStatsCard(context, challenge, streakStatus),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, Map<String, dynamic> streakStatus) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: DexterTokens.dexGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: DexterTokens.dexGreen,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Streak: ${streakStatus['streakLength']}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${streakStatus['livesImpacted']} lives potentially impacted',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Time remaining indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: streakStatus['isExpiringSoon'] 
                    ? DexterTokens.warning.withOpacity(0.1)
                    : DexterTokens.dexBlood.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: streakStatus['isExpiringSoon'] 
                        ? DexterTokens.warning 
                        : DexterTokens.dexBlood,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      streakStatus['isExpired']
                          ? 'Challenge has expired'
                          : '${streakStatus['daysRemaining']} days remaining',
                      style: TextStyle(
                        color: streakStatus['isExpiringSoon'] 
                            ? DexterTokens.warning 
                            : DexterTokens.dexBlood,
                        fontWeight: FontWeight.bold,
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

  Widget _buildProgressCard(
    BuildContext context,
    dynamic challenge,
    Map<String, dynamic> streakStatus,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Challenge Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Progress bar
            LinearProgressIndicator(
              value: (30 - streakStatus['daysRemaining']) / 30,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                streakStatus['isExpiringSoon'] 
                    ? DexterTokens.warning 
                    : DexterTokens.dexBlood,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status info
            Text(
              'Status: ${challenge.status}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Created: ${_formatDate(challenge.createdAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Last activity: ${_formatDate(challenge.lastChainEventAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(
    BuildContext context,
    WidgetRef ref,
    dynamic challenge,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/bloodline/verify-code'),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Verify Code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _nominateFriend(context, ref, challenge.id),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Nominate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNominationsCard(
    BuildContext context,
    WidgetRef ref,
    String challengeId,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nominations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            StreamBuilder(
              stream: ref.read(bloodlineRepositoryProvider).getChallengeNominations(challengeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error loading nominations: ${snapshot.error}');
                }

                final nominations = snapshot.data ?? [];
                
                if (nominations.isEmpty) {
                  return Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No nominations yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _nominateFriend(context, ref, challengeId),
                        child: const Text('Nominate a Friend'),
                      ),
                    ],
                  );
                }

                return Column(
                  children: nominations.map<Widget>((nomination) {
                    return _buildNominationItem(nomination);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNominationItem(dynamic nomination) {
    IconData statusIcon;
    Color statusColor;
    
    switch (nomination.status) {
      case 'sent':
        statusIcon = Icons.send;
        statusColor = Colors.orange;
        break;
      case 'joined':
        statusIcon = Icons.person_add;
        statusColor = Colors.blue;
        break;
      case 'donated':
        statusIcon = Icons.favorite;
        statusColor = DexterTokens.dexBlood;
        break;
      default:
        statusIcon = Icons.help;
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nomination.inviteeContact,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              nomination.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    dynamic challenge,
    Map<String, dynamic> streakStatus,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Challenge Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total\nDonations',
                    '${streakStatus['streakLength']}',
                    Icons.favorite,
                    DexterTokens.dexGreen,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Lives\nImpacted',
                    '${streakStatus['livesImpacted']}',
                    Icons.people,
                    DexterTokens.dexBlood,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Days\nActive',
                    '${DateTime.now().difference(challenge.createdAt).inDays}',
                    Icons.calendar_today,
                    DexterTokens.dexLeaf,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _shareChallenge(BuildContext context, WidgetRef ref) {
    // TODO: Generate and share challenge achievement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing feature coming soon!'),
      ),
    );
  }

  void _nominateFriend(BuildContext context, WidgetRef ref, String challengeId) {
    showDialog(
      context: context,
      builder: (context) => _NominateFriendDialog(challengeId: challengeId),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _NominateFriendDialog extends ConsumerStatefulWidget {
  final String challengeId;

  const _NominateFriendDialog({required this.challengeId});

  @override
  ConsumerState<_NominateFriendDialog> createState() => _NominateFriendDialogState();
}

class _NominateFriendDialogState extends ConsumerState<_NominateFriendDialog> {
  final _contactController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitNomination() async {
    if (_contactController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authStateProvider);
      final currentUser = authState.value;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final nominationService = ref.read(nominationServiceProvider);
      await nominationService.createNomination(
        challengeId: widget.challengeId,
        inviterUid: currentUser.uid,
        inviteeContact: _contactController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nomination sent successfully!'),
            backgroundColor: DexterTokens.dexBlood,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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
      title: const Text('Nominate a Friend'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Invite a friend to help keep your Bloodline chain alive!',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contactController,
            decoration: const InputDecoration(
              labelText: 'Friend\'s Email or Phone',
              hintText: 'friend@example.com',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitNomination,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Invite'),
        ),
      ],
    );
  }
}
