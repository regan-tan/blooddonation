import '../data/bloodline_repository.dart';
import '../domain/bloodline_challenge.dart';
import '../domain/donation_event.dart';
import '../../../features/auth/data/auth_repository.dart';

class StreakService {
  final BloodlineRepository _repository;
  final AuthRepository _authRepository;

  StreakService(this._repository, this._authRepository) {
    print('StreakService constructor called');
    print('BloodlineRepository: $_repository');
    print('AuthRepository: $_authRepository');
    
    if (_authRepository == null) {
      print('ERROR: _authRepository is null in constructor!');
      throw Exception('AuthRepository cannot be null');
    }
    
    if (_repository == null) {
      print('ERROR: _repository is null in constructor!');
      throw Exception('BloodlineRepository cannot be null');
    }
    
    print('StreakService constructor completed successfully');
  }

  /// Process a donation event and update challenge streak if applicable
  Future<void> processDonationEvent({
    required DonationEvent donationEvent,
    String? challengeId,
  }) async {
    print('StreakService.processDonationEvent called with code: ${donationEvent.code}');
    print('Donation event details: uid=${donationEvent.uid}, centreId=${donationEvent.centreId}');
    
    try {
      // For hardcoded test codes, always update impact stats directly
      if (donationEvent.code == 'BLD04Q0RWG') {
        print('Processing hardcoded test code - bypassing challenge lookup');
        await processTestCodeDonation(donationEvent.uid);
        return;
      }

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
        // Even without a challenge, track the donation impact
        await updateStandaloneDonationImpact(donationEvent.uid);
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

      // Update user's impact stats
      await _updateUserImpactStats(donationEvent.uid, newStreakLength);

      print('Challenge ${challenge.id} streak updated to $newStreakLength');
    } catch (e) {
      print('Error processing donation event: $e');
      
      // Even if challenge processing fails, try to update impact stats
      try {
        print('Attempting to update impact stats despite challenge error...');
        await updateStandaloneDonationImpact(donationEvent.uid);
      } catch (impactError) {
        print('Failed to update impact stats: $impactError');
      }
    }
  }

  /// Update user's impact statistics when a donation is verified
  Future<void> _updateUserImpactStats(String uid, int newStreakLength) async {
    try {
      // Each donation impacts 3 lives
      const livesPerDonation = 3;
      
      // Increment total lives impacted
      await _authRepository.incrementTotalLivesImpacted(uid, livesPerDonation);
      
      // Update longest streak if current streak is longer
      final userProfile = await _authRepository.getUserProfile(uid);
      if (userProfile != null && newStreakLength > userProfile.longestStreak) {
        await _authRepository.updateLongestStreak(uid, newStreakLength);
        print('Updated longest streak for user $uid to $newStreakLength');
      }
      
      print('Updated impact stats for user $uid: +$livesPerDonation lives, streak: $newStreakLength');
    } catch (e) {
      print('Error updating user impact stats: $e');
    }
  }

  /// Update impact stats for a standalone donation (no active challenge)
  Future<void> updateStandaloneDonationImpact(String uid) async {
    try {
      print('Starting standalone donation impact update for user: $uid');
      
      // Each donation impacts 3 lives
      const livesPerDonation = 3;
      
      // Get current profile to see existing values
      final userProfile = await _authRepository.getUserProfile(uid);
      if (userProfile != null) {
        print('Current profile - Lives: ${userProfile.totalLivesImpacted}, Streak: ${userProfile.longestStreak}');
        
        // Increment total lives impacted
        await _authRepository.incrementTotalLivesImpacted(uid, livesPerDonation);
        print('Incremented total lives impacted by $livesPerDonation');
        
        // For standalone donations, increment streak by 1
        final newStreak = userProfile.longestStreak + 1;
        await _authRepository.updateLongestStreak(uid, livesPerDonation);
        print('Updated longest streak to: $newStreak');
        
        // Verify the update by reading the profile again
        final updatedProfile = await _authRepository.getUserProfile(uid);
        if (updatedProfile != null) {
          print('Updated profile - Lives: ${updatedProfile.totalLivesImpacted}, Streak: ${updatedProfile.longestStreak}');
          
          // Force a small delay to ensure Firestore has propagated the changes
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Read one more time to confirm the update
          final finalProfile = await _authRepository.getUserProfile(uid);
          if (finalProfile != null) {
            print('Final verification - Lives: ${finalProfile.totalLivesImpacted}, Streak: ${finalProfile.longestStreak}');
          }
        }
        
        print('Successfully updated standalone donation impact for user $uid: +$livesPerDonation lives, new streak: $newStreak');
      } else {
        print('User profile not found for uid: $uid');
      }
    } catch (e) {
      print('Error updating standalone donation impact: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Process test code donation (bypasses all challenge logic)
  Future<void> processTestCodeDonation(String uid) async {
    try {
      print('Processing test code donation for user: $uid');
      
      // Check if _authRepository is null
      if (_authRepository == null) {
        print('ERROR: _authRepository is null in processTestCodeDonation!');
        throw Exception('AuthRepository is null - cannot process donation');
      }
      
      print('AuthRepository is available: $_authRepository');
      
      // Test method call to verify _authRepository is working
      try {
        print('Testing _authRepository.getUserProfile call...');
        final testProfile = await _authRepository.getUserProfile(uid);
        print('Test call successful: ${testProfile?.displayName}');
      } catch (e) {
        print('Test call failed: $e');
      }
      
      // Each donation impacts 3 lives
      const livesPerDonation = 3;
      
      // Get current profile
      final userProfile = await _authRepository.getUserProfile(uid);
      if (userProfile != null) {
        print('Current profile - Lives: ${userProfile.totalLivesImpacted}, Streak: ${userProfile.longestStreak}');
        
        print('About to increment total lives impacted by $livesPerDonation...');
        // Update both stats directly
        await _authRepository.incrementTotalLivesImpacted(uid, livesPerDonation);
        print('Successfully incremented total lives impacted');
        
        print('About to update longest streak to ${userProfile.longestStreak + 1}...');
        await _authRepository.updateLongestStreak(uid, userProfile.longestStreak + 1);
        print('Successfully updated longest streak');
        
        print('Test code donation processed successfully');
        
        // Verify the update
        final updatedProfile = await _authRepository.getUserProfile(uid);
        if (updatedProfile != null) {
          print('Final profile - Lives: ${updatedProfile.totalLivesImpacted}, Streak: ${updatedProfile.longestStreak}');
        }
      } else {
        print('User profile is null - cannot update stats');
      }
    } catch (e) {
      print('Error processing test code donation: $e');
      print('Stack trace: ${StackTrace.current}');
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
