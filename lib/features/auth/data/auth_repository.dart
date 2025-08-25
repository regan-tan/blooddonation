import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_profile.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserProfile> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
    required int age,
    String? school,
    String? bloodType,
    String? photoUrl,
  }) async {
    final userProfile = UserProfile(
      uid: uid,
      email: email,
      displayName: displayName,
      age: age,
      school: school,
      bloodType: bloodType,
      photoUrl: photoUrl,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(userProfile.toJson());

    return userProfile;
  }

  Stream<UserProfile?> getCurrentUserProfile() {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    print('Getting current user profile for uid: ${user.uid}');

    // Trigger migration for existing users
    migrateUserProfileWithEmail(user.uid);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            print('User document does not exist for uid: ${user.uid}');
            return null;
          }
          
          final data = doc.data()!;
          print('User profile data: $data');
          
          final profile = UserProfile.fromJson(data);
          print('Parsed profile - Lives: ${profile.totalLivesImpacted}, Streak: ${profile.longestStreak}');
          
          return profile;
        });
  }

  /// Force refresh the current user profile by triggering a new snapshot
  Future<void> forceRefreshProfile() async {
    final user = currentUser;
    if (user == null) return;

    try {
      print('Force refreshing profile for user: ${user.uid}');
      
      // Force a new read from Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        print('Force refresh - Latest profile data: $data');
      }
    } catch (e) {
      print('Error force refreshing profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _firestore
        .collection('users')
        .doc(userProfile.uid)
        .update(userProfile.toJson());
  }

  /// Update user's total lives impacted count
  Future<void> updateTotalLivesImpacted(String uid, int newTotal) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'totalLivesImpacted': newTotal});
  }

  /// Update user's longest streak count
  Future<void> updateLongestStreak(String uid, int newStreak) async {
    try {
      print('Updating longest streak for user $uid to $newStreak');
      
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'longestStreak': newStreak});
      
      print('Successfully updated longestStreak to $newStreak');
    } catch (e) {
      print('Error updating longest streak: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  /// Increment user's total lives impacted by a specific amount
  Future<void> incrementTotalLivesImpacted(String uid, int increment) async {
    try {
      print('Incrementing total lives impacted for user $uid by $increment');
      
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        print('User document does not exist for uid: $uid');
        return;
      }
      
      final currentTotal = doc.data()?['totalLivesImpacted'] as int? ?? 0;
      final newTotal = currentTotal + increment;
      
      print('Current total: $currentTotal, New total: $newTotal');
      
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'totalLivesImpacted': newTotal});
      
      print('Successfully updated totalLivesImpacted to $newTotal');
    } catch (e) {
      print('Error incrementing total lives impacted: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromJson(doc.data()!);
  }

  // Migration function to add email to existing user profiles
  Future<void> migrateUserProfileWithEmail(String uid) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.uid != uid) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      
      // Check if email is already present
      if (data['email'] != null) return;

      // Add email from Firebase Auth to Firestore document
      await _firestore.collection('users').doc(uid).update({
        'email': user.email ?? 'No email',
      });
    } catch (e) {
      print('Error migrating user profile with email: $e');
    }
  }
}
