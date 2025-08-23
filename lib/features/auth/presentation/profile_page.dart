import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showSignOutDialog(context, ref),
          ),
        ],
      ),
      body: authState.when(
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          
          return userProfile.when(
            data: (profile) => _buildProfileContent(context, ref, profile),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading profile: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Authentication error: $error'),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context, 
    WidgetRef ref, 
    dynamic profile,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: DexterTokens.dexGreen,
                    backgroundImage: profile?.photoUrl != null 
                        ? NetworkImage(profile!.photoUrl!) 
                        : null,
                    child: profile?.photoUrl == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.displayName ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Age: ${profile?.age ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (profile?.school != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      profile!.school!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Lives Impacted',
                  '${profile?.totalLivesImpacted ?? 0}',
                  Icons.favorite,
                  DexterTokens.dexGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Longest Streak',
                  '${profile?.longestStreak ?? 0}',
                  Icons.local_fire_department,
                  DexterTokens.dexLeaf,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Current Challenge Status
          if (profile?.currentChallengeId != null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: DexterTokens.dexBlood,
                      size: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Challenge',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'You have an ongoing Bloodline challenge',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Settings & Information
          _buildSettingsSection(context),
          
          const SizedBox(height: 20),
          
          // Age Consent Notice
          if (profile?.age != null && profile!.age >= 16 && profile.age <= 17)
            Card(
              color: Colors.orange[50],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'As you\'re 16-17 years old, parental consent is required for blood donation.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            'HSA Donation Guidelines',
            Icons.info_outline,
            () => _showHSAGuidelines(context),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            'Privacy Settings',
            Icons.privacy_tip,
            () => _showPrivacySettings(context),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            'App Information',
            Icons.help_outline,
            () => _showAppInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authRepositoryProvider).signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showHSAGuidelines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('HSA Donation Guidelines'),
        content: const SingleChildScrollView(
          child: Text(
            'Blood Donation Guidelines:\n\n'
            '• Minimum 12 weeks between donations for males\n'
            '• Minimum 16 weeks between donations for females\n'
            '• Age 16-65 years old\n'
            '• Weight at least 45kg\n'
            '• Good health condition\n\n'
            'Always follow HSA guidelines and consult with medical staff.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text(
          'Your privacy is important to us. We only collect data necessary for the app functionality and follow strict privacy guidelines.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloodline SG'),
        content: const Text(
          'Version 1.0.0\n\n'
          'A peer-led blood donation app for Singapore youths aged 16-25.\n\n'
          'Built with Flutter for positive social impact.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
