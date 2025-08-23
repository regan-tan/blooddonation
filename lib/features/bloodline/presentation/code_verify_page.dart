import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../state/providers.dart';
import '../../../core/theme/dexter_theme.dart';

class CodeVerifyPage extends ConsumerStatefulWidget {
  const CodeVerifyPage({super.key});

  @override
  ConsumerState<CodeVerifyPage> createState() => _CodeVerifyPageState();
}

class _CodeVerifyPageState extends ConsumerState<CodeVerifyPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCentreId;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate() || _selectedCentreId == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final codesRepository = ref.read(codesRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final currentUser = authState.value;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final donationEvent = await codesRepository.validateAndConsumeCode(
        code: _codeController.text.trim().toUpperCase(),
        uid: currentUser.uid,
        centreId: _selectedCentreId!,
      );

      if (donationEvent == null) {
        throw Exception('Invalid code or code already used');
      }

      // Process the donation event for streak updates
      final streakService = ref.read(streakServiceProvider);
      await streakService.processDonationEvent(donationEvent: donationEvent);

      if (mounted) {
        _showSuccessDialog(donationEvent);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
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

  void _showSuccessDialog(dynamic donationEvent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: DexterTokens.dexBlood),
            SizedBox(width: 8),
            Text('Donation Verified!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              size: 64,
              color: DexterTokens.dexGreen,
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for your donation!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your donation could potentially save up to 3 lives.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DexterTokens.dexBlood.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Code: ${donationEvent.code}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showShareDialog();
            },
            child: const Text('Share Achievement'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/bloodline');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Your Impact'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share,
              size: 48,
              color: DexterTokens.dexLeaf,
            ),
            SizedBox(height: 16),
            Text(
              'Share your donation with friends and inspire them to join your Bloodline!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sharing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing feature coming soon!'),
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final centresAsync = ref.watch(centresListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Donation Code'),
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
                        Icons.qr_code_scanner,
                        size: 64,
                        color: DexterTokens.dexGreen,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter Your Donation Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the unique code you received after your blood donation',
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
              
              // Centre Selection
              centresAsync.when(
                data: (centres) => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Donation Centre',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  initialValue: _selectedCentreId,
                  items: centres.map((centre) {
                    return DropdownMenuItem(
                      value: centre.id,
                      child: Text(
                        centre.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCentreId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a donation centre';
                    }
                    return null;
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading centres: $error'),
              ),
              
              const SizedBox(height: 16),
              
              // Code Input
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Donation Code',
                  prefixIcon: Icon(Icons.confirmation_number),
                  hintText: 'e.g., ABC123',
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your donation code';
                  }
                  if (value.trim().length < 6) {
                    return 'Code must be at least 6 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Verify Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Verify Donation'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Alternative Action
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement QR scanner
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('QR scanner coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Code Instead'),
              ),
              
              const SizedBox(height: 24),
              
              // Information Card
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
                            'About Donation Codes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: DexterTokens.dexLeaf,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• You receive a unique code after each donation\n'
                        '• Each code can only be used once\n'
                        '• Codes help track your Bloodline streak\n'
                        '• Contact staff if you didn\'t receive a code',
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
}
