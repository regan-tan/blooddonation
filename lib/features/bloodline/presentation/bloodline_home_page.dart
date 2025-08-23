import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';
import '../../../core/widgets/dex_buttons.dart';
import '../../../core/widgets/dex_cards.dart';
import '../../../core/widgets/dex_states.dart';
import '../../../core/widgets/dex_dino.dart';

class BloodlineHomePage extends ConsumerWidget {
  const BloodlineHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentChallenge = ref.watch(currentChallengeProvider);
    final userProfile = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloodline'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentChallengeProvider);
          ref.invalidate(currentUserProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Current Challenge Status
              currentChallenge.when(
                data: (challenge) {
                  if (challenge == null) {
                    return _buildNoChallengeCard(context);
                  }
                  return _buildChallengeCard(context, ref, challenge);
                },
                loading: () => const _LoadingCard(),
                error: (error, stack) => _buildErrorCard('Error loading challenge: $error'),
              ),
              
              const SizedBox(height: 20),
              
              // Quick Actions
              _buildQuickActions(context),
              
              const SizedBox(height: 20),
              
              // User Stats
              userProfile.when(
                data: (profile) => _buildUserStats(profile),
                loading: () => const _LoadingCard(),
                error: (error, stack) => _buildErrorCard('Error loading profile: $error'),
              ),
              
              const SizedBox(height: 20),
              
              // Weekly Leaderboard Preview
              _buildLeaderboardPreview(context),
              
              const SizedBox(height: 20),
              
              // HSA Guidelines Reminder
              _buildHSAReminder(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoChallengeCard(BuildContext context) {
    return DexCard(
      child: Column(
        children: [
          // Our adorable Dexter mascot!
          DexDinoAvatar(
            size: 120,
            showBloodBag: false,
            animate: true,
            onTap: () {
              HapticFeedback.lightImpact();
              // Maybe show a cute message or animation
            },
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Start Your Bloodline',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: DexterTokens.dexForest,
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
          
          const SizedBox(height: 12),
          
          Text(
            'Create a 1-v-1 challenge with a friend and build a donation chain that saves lives! 💚',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: DexterTokens.dexForest.withOpacity(0.8),
            ),
          ).animate(delay: 300.ms).fadeIn(),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: DexPrimaryButton(
                  text: 'Verify Code',
                  icon: Icons.qr_code_scanner,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/bloodline/verify-code');
                  },
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DexSecondaryButton(
                  text: 'Start 1-v-1',
                  icon: Icons.people,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/bloodline/challenge/create');
                  },
                ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext context, WidgetRef ref, dynamic challenge) {
    final streakService = ref.read(streakServiceProvider);
    final streakStatus = streakService.getStreakStatus(challenge);
    
    return DexCard(
      title: 'Active Bloodline 🔥',
      headerIcon: Icons.timeline,
      child: Column(
        children: [
          // Large streak counter
          DexStatPill(
            value: '${streakStatus['streakLength']}',
            label: 'Day Streak',
            icon: Icons.local_fire_department,
            color: DexterTokens.dexBlood,
            isLarge: true,
          ),
          
          const SizedBox(height: 20),
          
          // Lives impacted
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DexterTokens.dexGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
              border: Border.all(
                color: DexterTokens.dexGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  color: DexterTokens.dexBlood,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '${streakStatus['livesImpacted']} Lives Potentially Saved',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DexterTokens.dexForest,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Expiry warning badge
          if (streakStatus['isExpiringSoon'])
            DexBadge(
              text: '⚠️ ${streakStatus['daysRemaining']} days left',
              backgroundColor: DexterTokens.warning,
              isPulse: true,
            ).animate().shake(
              duration: 300.ms,
              hz: 2,
            ),
          
          const SizedBox(height: 20),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chain Progress',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: DexterTokens.dexForest,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: DexterTokens.dexLeaf.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (30 - streakStatus['daysRemaining']) / 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: streakStatus['isExpiringSoon'] 
                          ? DexterTokens.warning 
                          : DexterTokens.dexGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: DexPrimaryButton(
                  text: 'Verify Code',
                  icon: Icons.qr_code_scanner,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/bloodline/verify-code');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DexSecondaryButton(
                  text: 'View Details',
                  icon: Icons.visibility,
                  onPressed: () => context.push('/bloodline/challenge/${challenge.id}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Verify\nDonation',
                    Icons.qr_code_scanner,
                    DexterTokens.dexGreen,
                    () => context.push('/bloodline/verify-code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Start\nChallenge',
                    Icons.add_circle,
                    DexterTokens.dexLeaf,
                    () => context.push('/bloodline/challenge/create'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Find\nCentres',
                    Icons.location_on,
                    DexterTokens.dexBlood,
                    () => context.go('/centres'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats(dynamic profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Impact',
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
                    'Total Lives\nImpacted',
                    '${profile?.totalLivesImpacted ?? 0}',
                    Icons.favorite,
                    DexterTokens.dexGreen,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Longest\nStreak',
                    '${profile?.longestStreak ?? 0}',
                    Icons.local_fire_department,
                    DexterTokens.warning,
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
            fontSize: 24,
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

  Widget _buildLeaderboardPreview(BuildContext context) {
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
                  'Weekly Leaders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full leaderboard
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Top Bloodline chains this week coming soon!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHSAReminder(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: DexterTokens.dexLeaf,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remember HSA Guidelines',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: DexterTokens.dexLeaf,
                    ),
                  ),
                  Text(
                    'Follow donation intervals and let friends keep your chain alive between your eligible donation windows.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
