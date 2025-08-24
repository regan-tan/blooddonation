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

    // Trigger migration for existing users
    migrateUserProfileWithEmail(user.uid);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserProfile.fromJson(doc.data()!);
        });
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _firestore
        .collection('users')
        .doc(userProfile.uid)
        .update(userProfile.toJson());
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
