import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../state/providers.dart';

class DeepLinkHandler {
  final WidgetRef ref;

  DeepLinkHandler(this.ref);

  void handleDynamicLink(PendingDynamicLinkData linkData) {
    final Uri uri = linkData.link;
    print('Received dynamic link: $uri');

    try {
      _processLink(uri);
    } catch (e) {
      print('Error processing deep link: $e');
    }
  }

  void _processLink(Uri uri) {
    final path = uri.path;
    final queryParams = uri.queryParameters;

    // Handle different types of deep links
    if (path == '/join' && queryParams.containsKey('challenge')) {
      _handleChallengeInvite(queryParams);
    } else if (path == '/booking' && queryParams.containsKey('id')) {
      _handleBookingInvite(queryParams);
    } else if (path == '/centre' && queryParams.containsKey('id')) {
      _handleCentreView(queryParams);
    } else {
      // Default to home page
      _navigateToHome();
    }
  }

  void _handleChallengeInvite(Map<String, String> params) {
    final challengeId = params['challenge'];
    final inviterUid = params['inviter'];

    if (challengeId == null) {
      _navigateToHome();
      return;
    }

    // Check if user is authenticated
    final authState = ref.read(authStateProvider);
    if (authState.value == null) {
      // Store the invitation and redirect to sign in
      // TODO: Store invitation to handle after sign in
      _navigateToSignIn();
      return;
    }

    // Navigate to challenge
    _navigateToChallenge(challengeId);
    
    // Show invitation dialog
    _showChallengeInviteDialog(challengeId, inviterUid);
  }

  void _handleBookingInvite(Map<String, String> params) {
    final bookingId = params['id'];

    if (bookingId == null) {
      _navigateToHome();
      return;
    }

    // Check if user is authenticated
    final authState = ref.read(authStateProvider);
    if (authState.value == null) {
      _navigateToSignIn();
      return;
    }

    // Navigate to booking
    _navigateToBooking(bookingId);
  }

  void _handleCentreView(Map<String, String> params) {
    final centreId = params['id'];

    if (centreId == null) {
      _navigateToHome();
      return;
    }

    // Navigate to centre (no auth required)
    _navigateToCentre(centreId);
  }

  void _navigateToHome() {
    // Get the current router from the app
    // Note: In a real implementation, you'd have access to the router context
    print('Navigating to home');
    // router.go('/bloodline');
  }

  void _navigateToSignIn() {
    print('Navigating to sign in');
    // router.go('/sign-in');
  }

  void _navigateToChallenge(String challengeId) {
    print('Navigating to challenge: $challengeId');
    // router.go('/bloodline/challenge/$challengeId');
  }

  void _navigateToBooking(String bookingId) {
    print('Navigating to booking: $bookingId');
    // router.go('/bookings/$bookingId');
  }

  void _navigateToCentre(String centreId) {
    print('Navigating to centre: $centreId');
    // router.go('/centres/$centreId');
  }

  void _showChallengeInviteDialog(String challengeId, String? inviterUid) {
    // TODO: Implement challenge invite dialog
    print('Showing challenge invite dialog for challenge: $challengeId');
    
    // In a real implementation, this would show a dialog to join the challenge
    // and handle the invitation acceptance
  }
}
