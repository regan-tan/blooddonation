import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/bloodline_challenge.dart';
import '../domain/nomination.dart';

class BloodlineRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Create a new 1-v-1 challenge
  Future<BloodlineChallenge> createChallenge({
    required String userAUid,
    required String userBUid,
  }) async {
    final challenge = BloodlineChallenge(
      id: _uuid.v4(),
      userAUid: userAUid,
      userBUid: userBUid,
      createdAt: DateTime.now(),
      lastChainEventAt: DateTime.now(),
      streakLength: 0,
      status: 'active',
    );

    await _firestore
        .collection('challenges')
        .doc(challenge.id)
        .set(challenge.toJson());

    return challenge;
  }

  /// Get current active challenge for a user
  Stream<BloodlineChallenge?> getCurrentChallenge(String uid) {
    return _firestore
        .collection('challenges')
        .where('status', isEqualTo: 'active')
        .where('userAUid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return BloodlineChallenge.fromJson(snapshot.docs.first.data());
          }
          
          // Also check if user is userB in any challenge
          return null;
        });
  }

  /// Get challenge by ID
  Future<BloodlineChallenge?> getChallengeById(String challengeId) async {
    final doc = await _firestore.collection('challenges').doc(challengeId).get();
    if (!doc.exists) return null;
    return BloodlineChallenge.fromJson(doc.data()!);
  }

  /// Update challenge streak
  Future<void> updateChallengeStreak({
    required String challengeId,
    required int newStreakLength,
    required String leaderUid,
    required DateTime lastChainEventAt,
  }) async {
    await _firestore.collection('challenges').doc(challengeId).update({
      'streakLength': newStreakLength,
      'leaderUid': leaderUid,
      'lastChainEventAt': Timestamp.fromDate(lastChainEventAt),
    });
  }

  /// End a challenge
  Future<void> endChallenge(String challengeId) async {
    await _firestore.collection('challenges').doc(challengeId).update({
      'status': 'ended',
    });
  }

  /// Create a nomination
  Future<Nomination> createNomination({
    required String challengeId,
    required String inviterUid,
    required String inviteeContact,
    required String inviteLink,
  }) async {
    final nomination = Nomination(
      id: _uuid.v4(),
      challengeId: challengeId,
      inviterUid: inviterUid,
      inviteeContact: inviteeContact,
      inviteLink: inviteLink,
      status: 'sent',
    );

    await _firestore
        .collection('nominations')
        .doc(nomination.id)
        .set(nomination.toJson());

    return nomination;
  }

  /// Get nominations for a challenge
  Stream<List<Nomination>> getChallengeNominations(String challengeId) {
    return _firestore
        .collection('nominations')
        .where('challengeId', isEqualTo: challengeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Nomination.fromJson(doc.data()))
            .toList());
  }

  /// Update nomination status
  Future<void> updateNominationStatus({
    required String nominationId,
    required String status,
    String? donationEventId,
  }) async {
    final updateData = {'status': status};
    if (donationEventId != null) {
      updateData['donationEventId'] = donationEventId;
    }

    await _firestore
        .collection('nominations')
        .doc(nominationId)
        .update(updateData);
  }

  /// Get user's challenge history
  Future<List<BloodlineChallenge>> getUserChallengeHistory(String uid) async {
    final querySnapshot = await _firestore
        .collection('challenges')
        .where('userAUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    final challenges = querySnapshot.docs
        .map((doc) => BloodlineChallenge.fromJson(doc.data()))
        .toList();

    // Also get challenges where user is userB
    final querySnapshotB = await _firestore
        .collection('challenges')
        .where('userBUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    challenges.addAll(querySnapshotB.docs
        .map((doc) => BloodlineChallenge.fromJson(doc.data())));

    // Sort by creation date
    challenges.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return challenges;
  }

  /// Get weekly leaderboard
  Future<List<Map<String, dynamic>>> getWeeklyLeaderboard() async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    final querySnapshot = await _firestore
        .collection('challenges')
        .where('lastChainEventAt', isGreaterThan: Timestamp.fromDate(weekAgo))
        .orderBy('streakLength', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'challenge': BloodlineChallenge.fromJson(doc.data()),
              'id': doc.id,
            })
        .toList();
  }

  /// Check if user already has an active challenge
  Future<bool> hasActiveChallenge(String uid) async {
    final querySnapshot = await _firestore
        .collection('challenges')
        .where('status', isEqualTo: 'active')
        .where('userAUid', isEqualTo: uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) return true;

    // Also check if user is userB
    final querySnapshotB = await _firestore
        .collection('challenges')
        .where('status', isEqualTo: 'active')
        .where('userBUid', isEqualTo: uid)
        .limit(1)
        .get();

    return querySnapshotB.docs.isNotEmpty;
  }
}
