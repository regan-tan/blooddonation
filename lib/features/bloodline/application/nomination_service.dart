import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';
import '../data/bloodline_repository.dart';
import '../domain/nomination.dart';

class NominationService {
  final BloodlineRepository _repository;

  NominationService(this._repository);

  /// Create and send a nomination
  Future<Nomination> createNomination({
    required String challengeId,
    required String inviterUid,
    required String inviteeContact,
  }) async {
    try {
      // Generate dynamic link for the invitation
      final inviteLink = await _generateInviteLink(challengeId, inviterUid);

      // Create nomination record
      final nomination = await _repository.createNomination(
        challengeId: challengeId,
        inviterUid: inviterUid,
        inviteeContact: inviteeContact,
        inviteLink: inviteLink,
      );

      return nomination;
    } catch (e) {
      print('Error creating nomination: $e');
      rethrow;
    }
  }

  /// Generate a Firebase Dynamic Link for invitation
  Future<String> _generateInviteLink(String challengeId, String inviterUid) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bloodlinesg.page.link', // Configure this in Firebase Console
        link: Uri.parse('https://bloodlinesg.app/join?challenge=$challengeId&inviter=$inviterUid'),
        androidParameters: const AndroidParameters(
          packageName: 'sg.bloodline.bloodline_sg',
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: 'sg.bloodline.bloodlineSg',
          minimumVersion: '1.0.0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join my Bloodline Challenge!',
          description: 'Let\'s save lives together through blood donation',
          imageUrl: Uri.parse('https://bloodlinesg.app/images/share-banner.png'),
        ),
      );

      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance
          .buildShortLink(parameters);

      return shortLink.shortUrl.toString();
    } catch (e) {
      print('Error generating dynamic link: $e');
      // Fallback to a basic share link
      return 'https://bloodlinesg.app/join?challenge=$challengeId&inviter=$inviterUid';
    }
  }

  /// Share invitation via platform share sheet
  Future<void> shareInvitation({
    required String challengeId,
    required String inviteLink,
    required String inviterName,
  }) async {
    try {
      final shareText = '''
🩸 Join my Bloodline Challenge!

Hi! I'm challenging friends to create a blood donation chain that saves lives.

Every donation keeps our streak alive and helps save up to 3 lives. Let's make a difference together!

Join here: $inviteLink

#BloodlineSG #SaveLives
''';

      await Share.share(
        shareText,
        subject: '$inviterName invited you to join their Bloodline Challenge',
      );
    } catch (e) {
      print('Error sharing invitation: $e');
    }
  }

  /// Process when a nominee joins a challenge
  Future<void> processNomineeJoined({
    required String nominationId,
    required String nomineeUid,
  }) async {
    try {
      await _repository.updateNominationStatus(
        nominationId: nominationId,
        status: 'joined',
      );

      print('Nominee $nomineeUid joined nomination $nominationId');
    } catch (e) {
      print('Error processing nominee joined: $e');
    }
  }

  /// Process when a nominee donates
  Future<void> processNomineeDonation({
    required String nominationId,
    required String donationEventId,
  }) async {
    try {
      await _repository.updateNominationStatus(
        nominationId: nominationId,
        status: 'donated',
        donationEventId: donationEventId,
      );

      print('Nominee donation processed for nomination $nominationId');
    } catch (e) {
      print('Error processing nominee donation: $e');
    }
  }

  /// Generate shareable achievement banner
  Map<String, dynamic> generateAchievementBanner({
    required String challengerName,
    required int streakLength,
    required int livesImpacted,
  }) {
    return {
      'title': 'Bloodline Achievement!',
      'subtitle': '$challengerName\'s Chain',
      'streakLength': streakLength,
      'livesImpacted': livesImpacted,
      'shareText': '''
🩸 Incredible! Our Bloodline chain has reached $streakLength donations!

Together we've potentially saved $livesImpacted lives through our blood donation streak.

Join the movement: #BloodlineSG
''',
    };
  }

  /// Get nomination statistics for a challenge
  Future<Map<String, dynamic>> getNominationStats(String challengeId) async {
    try {
      final nominations = await _repository
          .getChallengeNominations(challengeId)
          .first;

      final totalNominations = nominations.length;
      final joinedCount = nominations.where((n) => n.status == 'joined' || n.status == 'donated').length;
      final donatedCount = nominations.where((n) => n.status == 'donated').length;

      return {
        'total': totalNominations,
        'joined': joinedCount,
        'donated': donatedCount,
        'conversionRate': totalNominations > 0 ? (joinedCount / totalNominations) : 0.0,
        'donationRate': joinedCount > 0 ? (donatedCount / joinedCount) : 0.0,
      };
    } catch (e) {
      print('Error getting nomination stats: $e');
      return {
        'total': 0,
        'joined': 0,
        'donated': 0,
        'conversionRate': 0.0,
        'donationRate': 0.0,
      };
    }
  }
}
