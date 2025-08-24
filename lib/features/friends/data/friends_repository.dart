import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../domain/friend.dart';

class FriendsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Search for users by email
  Future<Map<String, dynamic>?> searchUserByEmail(String email) async {
    try {
      final searchEmail = email.toLowerCase().trim();
      if (kDebugMode) print('Searching for email: $searchEmail');
      
      // Search all user documents and print their structure for debugging
      final allUsersSnapshot = await _firestore.collection('users').get();
      if (kDebugMode) print('Total users in Firestore: ${allUsersSnapshot.docs.length}');
      
      for (final doc in allUsersSnapshot.docs) {
        final data = doc.data();
        if (kDebugMode) print('User document ${doc.id}: $data');
        
        // Check multiple possible email field names
        final userEmail = (data['email'] ?? data['userEmail'] ?? data['emailAddress'])?.toString().toLowerCase().trim();
        
        if (kDebugMode) print('Extracted email: $userEmail, comparing with: $searchEmail');
        
        if (userEmail == searchEmail) {
          if (kDebugMode) print('Found matching user data: $data');
          return {
            'uid': doc.id,
            'email': userEmail ?? searchEmail,
            'displayName': data['displayName'] ?? data['name'] ?? data['userName'] ?? 'Unknown User',
            'photoUrl': data['photoUrl'] ?? data['profilePicture'],
          };
        }
      }
      
      if (kDebugMode) print('User not found with email: $searchEmail');
      return null;
    } catch (e) {
      if (kDebugMode) print('Error searching for user: $e');
      throw Exception('Error searching for user: $e');
    }
  }

  // Search for users by display name
  Future<List<Map<String, dynamic>>> searchUserByDisplayName(String displayName) async {
    try {
      final searchName = displayName.toLowerCase().trim();
      final results = <Map<String, dynamic>>[];
      
      final querySnapshot = await _firestore.collection('users').get();
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final userName = data['displayName']?.toString().toLowerCase().trim();
        
        if (userName != null && userName.contains(searchName)) {
          // Debug: Print the full user data to see the structure
          if (kDebugMode) print('Found user data: $data');
          
          // Try to get email from different possible field names
          final userEmail = data['email'] ?? data['userEmail'] ?? data['emailAddress'];
          
          results.add({
            'uid': doc.id,
            'email': userEmail?.toString() ?? 'No email stored',
            'displayName': data['displayName'] ?? data['name'] ?? data['userName'] ?? 'Unknown User',
            'photoUrl': data['photoUrl'] ?? data['profilePicture'],
          });
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('Error searching for user by name: $e');
    }
  }

  // Add a friend (NEW: Array-based approach)
  Future<void> addFriend(String friendUid, String friendEmail, String friendDisplayName, String? friendPhotoUrl) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final batch = _firestore.batch();
      
      // Get current user's data
      final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final currentUserData = currentUserDoc.data() ?? {};
      
      // Check if friend already exists in current user's friends array
      final currentFriends = List<Map<String, dynamic>>.from(currentUserData['friends'] ?? []);
      if (currentFriends.any((friend) => friend['uid'] == friendUid)) {
        throw Exception('User is already in your friends list');
      }

      // Add friend to current user's friends array
      final now = DateTime.now();
      final newFriend = {
        'uid': friendUid,
        'email': friendEmail,
        'displayName': friendDisplayName,
        'photoUrl': friendPhotoUrl,
        'addedAt': Timestamp.fromDate(now),
      };
      
      batch.update(_firestore.collection('users').doc(currentUser.uid), {
        'friends': FieldValue.arrayUnion([newFriend])
      });

      // Add current user to friend's friends array
      final currentUserFriend = {
        'uid': currentUser.uid,
        'email': currentUser.email ?? 'No email',
        'displayName': currentUserData['displayName'] ?? 'Unknown User',
        'photoUrl': currentUserData['photoUrl'],
        'addedAt': Timestamp.fromDate(now),
      };
      
      batch.update(_firestore.collection('users').doc(friendUid), {
        'friends': FieldValue.arrayUnion([currentUserFriend])
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Error adding friend: $e');
    }
  }

  // Get user's friends (NEW: Array-based approach)
  Future<List<Friend>> getUserFriends() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      
      if (!userDoc.exists) return [];
      
      final userData = userDoc.data() ?? {};
      final friendsArray = List<Map<String, dynamic>>.from(userData['friends'] ?? []);
      
      if (kDebugMode) {
        print('Current user friends array: $friendsArray');
        print('Friends array length: ${friendsArray.length}');
      }
      
      final friends = friendsArray.map((friendData) {
        if (kDebugMode) print('Processing friend data: $friendData');
        
        return Friend(
          id: '${currentUser.uid}_${friendData['uid']}', // Generate ID for compatibility
          uid: friendData['uid'] as String,
          email: friendData['email'] as String? ?? 'No email',
          displayName: friendData['displayName'] as String? ?? 'Unknown User',
          photoUrl: friendData['photoUrl'] as String?,
          addedAt: (friendData['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          status: 'accepted', // All friends in array are accepted
        );
      }).toList();

      // Sort by addedAt (newest first)
      friends.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      
      if (kDebugMode) print('Returning ${friends.length} friends: ${friends.map((f) => f.displayName).toList()}');
      
      return friends;
    } catch (e) {
      if (kDebugMode) print('Error fetching friends: $e');
      throw Exception('Error fetching friends: $e');
    }
  }

  // Remove friend (NEW: Array-based approach)
  Future<void> removeFriend(String friendUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final batch = _firestore.batch();
      
      // Get current user's friends array
      final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final currentUserData = currentUserDoc.data() ?? {};
      final currentFriends = List<Map<String, dynamic>>.from(currentUserData['friends'] ?? []);
      
      // Find and remove the friend from current user's array
      final friendToRemove = currentFriends.firstWhere(
        (friend) => friend['uid'] == friendUid,
        orElse: () => <String, dynamic>{},
      );
      
      if (friendToRemove.isNotEmpty) {
        batch.update(_firestore.collection('users').doc(currentUser.uid), {
          'friends': FieldValue.arrayRemove([friendToRemove])
        });
      }
      
      // Get friend's data and remove current user from their array
      final friendDoc = await _firestore.collection('users').doc(friendUid).get();
      final friendData = friendDoc.data() ?? {};
      final friendsFriends = List<Map<String, dynamic>>.from(friendData['friends'] ?? []);
      
      // Find and remove current user from friend's array
      final currentUserToRemove = friendsFriends.firstWhere(
        (friend) => friend['uid'] == currentUser.uid,
        orElse: () => <String, dynamic>{},
      );
      
      if (currentUserToRemove.isNotEmpty) {
        batch.update(_firestore.collection('users').doc(friendUid), {
          'friends': FieldValue.arrayRemove([currentUserToRemove])
        });
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Error removing friend: $e');
    }
  }

  // Get friends for a specific user (for group booking invitations) - NEW: Array-based
  Future<List<Friend>> getFriendsForUser(String userUid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userUid).get();
      
      if (!userDoc.exists) return [];
      
      final userData = userDoc.data() ?? {};
      final friendsArray = List<Map<String, dynamic>>.from(userData['friends'] ?? []);
      
      return friendsArray.map((friendData) {
        return Friend(
          id: '${userUid}_${friendData['uid']}',
          uid: friendData['uid'] as String,
          email: friendData['email'] as String? ?? 'No email',
          displayName: friendData['displayName'] as String? ?? 'Unknown User',
          photoUrl: friendData['photoUrl'] as String?,
          addedAt: (friendData['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          status: 'accepted',
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching user friends: $e');
    }
  }

  // MIGRATION: Convert from old friends collection to new array-based approach
  Future<void> migrateFriendsFromCollectionToArray() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      if (kDebugMode) print('Starting friends migration for user: ${currentUser.uid}');
      
      // Get old friends from the friends collection
      final oldFriendsSnapshot = await _firestore
          .collection('friends')
          .where('userUid', isEqualTo: currentUser.uid)
          .get();

      if (oldFriendsSnapshot.docs.isEmpty) {
        if (kDebugMode) print('No old friends found to migrate');
        return;
      }

      // Convert old friends to new format
      final friendsArray = <Map<String, dynamic>>[];
      for (final doc in oldFriendsSnapshot.docs) {
        final data = doc.data();
        friendsArray.add({
          'uid': data['friendUid'],
          'email': data['friendEmail'],
          'displayName': data['friendDisplayName'],
          'photoUrl': data['friendPhotoUrl'],
          'addedAt': data['addedAt'] ?? Timestamp.fromDate(DateTime.now()),
        });
      }

      // Update user document with friends array
      await _firestore.collection('users').doc(currentUser.uid).update({
        'friends': friendsArray,
      });

      if (kDebugMode) print('Successfully migrated ${friendsArray.length} friends to array format');

      // Optionally: Clean up old friends collection documents
      // (Comment out if you want to keep the old data as backup)
      /*
      final batch = _firestore.batch();
      for (final doc in oldFriendsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (kDebugMode) print('Cleaned up old friends collection documents');
      */

    } catch (e) {
      if (kDebugMode) print('Error during friends migration: $e');
    }
  }
}
