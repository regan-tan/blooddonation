import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class ChallengeCreatePage extends ConsumerStatefulWidget {
  const ChallengeCreatePage({super.key});

  @override
  ConsumerState<ChallengeCreatePage> createState() => _ChallengeCreatePageState();
}

class _ChallengeCreatePageState extends ConsumerState<ChallengeCreatePage> {
  final _friendContactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _friendContactController.dispose();
    super.dispose();
  }

  Future<void> _createChallenge() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authState = ref.read(authStateProvider);
      final currentUser = authState.value;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if user already has an active challenge
      final bloodlineRepository = ref.read(bloodlineRepositoryProvider);
      final hasActive = await bloodlineRepository.hasActiveChallenge(currentUser.uid);

      if (hasActive) {
        throw Exception('You already have an active challenge. Complete it first before starting a new one.');
      }

      // For now, we'll create a placeholder userB (in real app, this would involve friend invitation)
      final challenge = await bloodlineRepository.createChallenge(
        userAUid: currentUser.uid,
        userBUid: 'pending', // Will be updated when friend accepts
      );

      // Create nomination/invitation
      final nominationService = ref.read(nominationServiceProvider);
      final nomination = await nominationService.createNomination(
        challengeId: challenge.id,
        inviterUid: currentUser.uid,
        inviteeContact: _friendContactController.text.trim(),
      );

      if (mounted) {
        _showInviteDialog(challenge.id, nomination.inviteLink);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating challenge: ${e.toString()}'),
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

  void _showInviteDialog(String challengeId, String inviteLink) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: DexterTokens.dexBlood),
            SizedBox(width: 8),
            Text('Challenge Created!'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: DexterTokens.dexGreen,
            ),
            SizedBox(height: 16),
            Text(
              'Your 1-v-1 Bloodline Challenge is ready!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Share the invitation link with your friend to get started.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/bloodline');
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shareInvitation(challengeId, inviteLink);
            },
            child: const Text('Share Invite'),
          ),
        ],
      ),
    );
  }

  void _shareInvitation(String challengeId, String inviteLink) {
    final nominationService = ref.read(nominationServiceProvider);
    final userProfile = ref.read(currentUserProvider).value;
    
    nominationService.shareInvitation(
      challengeId: challengeId,
      inviteLink: inviteLink,
      inviterName: userProfile?.displayName ?? 'A friend',
    );

    context.go('/bloodline');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start 1-v-1 Challenge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 64,
                        color: DexterTokens.dexGreen,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Bloodline Challenge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Challenge a friend to build a blood donation chain together!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // How it Works
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How Bloodline Works',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildHowItWorksStep(
                        '1',
                        'Create Challenge',
                        'Invite a friend to join your Bloodline',
                      ),
                      _buildHowItWorksStep(
                        '2',
                        'Donate & Verify',
                        'Both of you donate and verify with codes',
                      ),
                      _buildHowItWorksStep(
                        '3',
                        'Keep Chain Alive',
                        'Nominate friends to donate within 30 days',
                      ),
                      _buildHowItWorksStep(
                        '4',
                        'Save Lives',
                        'Each donation can save up to 3 lives!',
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Friend Contact Input
              TextFormField(
                controller: _friendContactController,
                decoration: const InputDecoration(
                  labelText: 'Friend\'s Email or Phone',
                  prefixIcon: Icon(Icons.person_add),
                  hintText: 'friend@example.com or +65 1234 5678',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your friend\'s contact';
                  }
                  // Basic validation for email or phone
                  if (!value.contains('@') && !value.contains('+')) {
                    return 'Please enter a valid email or phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Create Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createChallenge,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Challenge'),
                ),
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
                          Icon(
                            Icons.info_outline,
                            color: DexterTokens.dexLeaf,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Important Guidelines',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: DexterTokens.dexLeaf,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Follow HSA donation intervals (12-16 weeks)\n'
                        '• Nominate friends to keep chain alive\n'
                        '• Chain expires after 30 days without donation\n'
                        '• Only one active challenge per user',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksStep(
    String number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: DexterTokens.dexGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
