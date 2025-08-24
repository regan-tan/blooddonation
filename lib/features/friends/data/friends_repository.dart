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

  // Add a friend
  Future<void> addFriend(String friendUid, String friendEmail, String friendDisplayName, String? friendPhotoUrl) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final friendId = '${currentUser.uid}_$friendUid';
      final reverseFriendId = '${friendUid}_${currentUser.uid}';

      // Check if friendship already exists
      final existingFriend = await _firestore
          .collection('friends')
          .doc(friendId)
          .get();

      if (existingFriend.exists) {
        throw Exception('User is already in your friends list');
      }

      // Create friend relationship (bidirectional)
      final batch = _firestore.batch();

      // Add friend from current user's perspective
      batch.set(
        _firestore.collection('friends').doc(friendId),
        {
          'id': friendId,
          'userUid': currentUser.uid,
          'friendUid': friendUid,
          'friendEmail': friendEmail,
          'friendDisplayName': friendDisplayName,
          'friendPhotoUrl': friendPhotoUrl,
          'addedAt': FieldValue.serverTimestamp(),
          'status': 'accepted', // For simplicity, auto-accept for now
        },
      );

      // Add reverse relationship (friend's perspective)
      final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final currentUserData = currentUserDoc.data();

      batch.set(
        _firestore.collection('friends').doc(reverseFriendId),
        {
          'id': reverseFriendId,
          'userUid': friendUid,
          'friendUid': currentUser.uid,
          'friendEmail': currentUser.email,
          'friendDisplayName': currentUserData?['displayName'] ?? 'Unknown User',
          'friendPhotoUrl': currentUserData?['photoUrl'],
          'addedAt': FieldValue.serverTimestamp(),
          'status': 'accepted',
        },
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Error adding friend: $e');
    }
  }

  // Get user's friends
  Future<List<Friend>> getUserFriends() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final querySnapshot = await _firestore
          .collection('friends')
          .where('userUid', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'accepted')
          .get();

      final friends = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Friend(
          id: data['id'],
          uid: data['friendUid'],
          email: data['friendEmail'],
          displayName: data['friendDisplayName'],
          photoUrl: data['friendPhotoUrl'],
          addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          status: data['status'],
        );
      }).toList();

      // Sort by addedAt in memory instead of using orderBy
      friends.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      
      return friends;
    } catch (e) {
      throw Exception('Error fetching friends: $e');
    }
  }

  // Remove friend
  Future<void> removeFriend(String friendUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final friendId = '${currentUser.uid}_$friendUid';
      final reverseFriendId = '${friendUid}_${currentUser.uid}';

      final batch = _firestore.batch();
      
      batch.delete(_firestore.collection('friends').doc(friendId));
      batch.delete(_firestore.collection('friends').doc(reverseFriendId));
      
      await batch.commit();
    } catch (e) {
      throw Exception('Error removing friend: $e');
    }
  }

  // Get friends for a specific user (for group booking invitations)
  Future<List<Friend>> getFriendsForUser(String userUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('friends')
          .where('userUid', isEqualTo: userUid)
          .where('status', isEqualTo: 'accepted')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Friend(
          id: data['id'],
          uid: data['friendUid'],
          email: data['friendEmail'],
          displayName: data['friendDisplayName'],
          photoUrl: data['friendPhotoUrl'],
          addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          status: data['status'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching user friends: $e');
    }
  }
}
