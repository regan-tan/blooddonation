import '../data/bloodline_repository.dart';
import '../domain/bloodline_challenge.dart';
import '../domain/donation_event.dart';

class StreakService {
  final BloodlineRepository _repository;

  StreakService(this._repository);

  /// Process a donation event and update challenge streak if applicable
  Future<void> processDonationEvent({
    required DonationEvent donationEvent,
    String? challengeId,
  }) async {
    try {
      // If no specific challenge provided, find the user's active challenge
      BloodlineChallenge? challenge;
      
      if (challengeId != null) {
        challenge = await _repository.getChallengeById(challengeId);
      } else {
        // Find active challenge where this user is a participant
        final userChallenges = await _repository.getUserChallengeHistory(donationEvent.uid);
        challenge = userChallenges
            .where((c) => c.status == 'active')
            .firstOrNull;
      }

      if (challenge == null) {
        print('No active challenge found for user ${donationEvent.uid}');
        return;
      }

      // Check if donation is within 30 days of last chain event
      final daysSinceLastEvent = DateTime.now()
          .difference(challenge.lastChainEventAt)
          .inDays;

      if (daysSinceLastEvent > 30) {
        // Chain has expired, end the challenge
        await _repository.endChallenge(challenge.id);
        print('Challenge ${challenge.id} ended due to 30-day timeout');
        return;
      }

      // Update streak
      final newStreakLength = challenge.streakLength + 1;
      
      await _repository.updateChallengeStreak(
        challengeId: challenge.id,
        newStreakLength: newStreakLength,
        leaderUid: donationEvent.uid,
        lastChainEventAt: donationEvent.donatedAt,
      );

      print('Challenge ${challenge.id} streak updated to $newStreakLength');
    } catch (e) {
      print('Error processing donation event: $e');
    }
  }

  /// Check if any challenges have expired (run periodically)
  Future<void> checkExpiredChallenges() async {
    try {
      // This would typically be implemented as a scheduled function
      // For now, we'll just mark it as a placeholder
      print('Checking for expired challenges...');
      
      // In a real implementation, you'd:
      // 1. Query all active challenges
      // 2. Check if lastChainEventAt is > 30 days ago
      // 3. Mark expired challenges as ended
    } catch (e) {
      print('Error checking expired challenges: $e');
    }
  }

  /// Calculate lives potentially impacted by a streak
  int calculateLivesImpacted(int streakLength) {
    // Each donation can potentially save up to 3 lives
    return streakLength * 3;
  }

  /// Get streak status for display
  Map<String, dynamic> getStreakStatus(BloodlineChallenge challenge) {
    final daysSinceLastEvent = DateTime.now()
        .difference(challenge.lastChainEventAt)
        .inDays;

    final daysRemaining = 30 - daysSinceLastEvent;
    final isExpired = daysRemaining <= 0;
    final isExpiringSoon = daysRemaining <= 3 && daysRemaining > 0;

    return {
      'streakLength': challenge.streakLength,
      'daysRemaining': daysRemaining.clamp(0, 30),
      'isExpired': isExpired,
      'isExpiringSoon': isExpiringSoon,
      'livesImpacted': calculateLivesImpacted(challenge.streakLength),
      'lastEventDate': challenge.lastChainEventAt,
    };
  }

  /// Validate if a user can donate (based on last donation)
  Future<Map<String, dynamic>> validateDonationEligibility({
    required String uid,
    DateTime? lastDonationDate,
  }) async {
    // Singapore HSA guidelines: minimum 12 weeks between donations for males,
    // 16 weeks for females. For simplicity, we'll use 12 weeks.
    const minIntervalWeeks = 12;
    
    if (lastDonationDate == null) {
      return {
        'eligible': true,
        'message': 'Eligible to donate',
      };
    }

    final weeksSinceLastDonation = DateTime.now()
        .difference(lastDonationDate)
        .inDays / 7;

    if (weeksSinceLastDonation >= minIntervalWeeks) {
      return {
        'eligible': true,
        'message': 'Eligible to donate',
      };
    }

    final weeksRemaining = (minIntervalWeeks - weeksSinceLastDonation).ceil();
    
    return {
      'eligible': false,
      'message': 'Must wait $weeksRemaining more weeks before next donation',
      'weeksRemaining': weeksRemaining,
    };
  }
}
