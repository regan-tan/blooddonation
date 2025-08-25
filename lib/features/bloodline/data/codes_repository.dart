import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/valid_code.dart';
import '../domain/donation_event.dart';

class CodesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Validates and consumes a donation code
  /// Returns a DonationEvent if successful, null if code is invalid or already used
  Future<DonationEvent?> validateAndConsumeCode({
    required String code,
    required String uid,
    required String centreId,
  }) async {
    try {
      // HARDCODED TESTING CODE: BLD04Q0RWG is always valid for testing
      if (code == 'BLD04Q0RWG') {
        print('Using hardcoded test code: BLD04Q0RWG');
        
        // Create donation event directly for test code
        final donationEvent = DonationEvent(
          id: _uuid.v4(),
          uid: uid,
          centreId: centreId,
          code: code,
          donatedAt: DateTime.now(),
          verified: true,
        );

        print('Created donation event: ${donationEvent.toJson()}');

        // Store donation event
        await _firestore
            .collection('donation_events')
            .doc(donationEvent.id)
            .set(donationEvent.toJson());

        print('Donation event stored in Firestore successfully');
        print('Returning donation event: ${donationEvent.code}');

        return donationEvent;
      }

      return await _firestore.runTransaction<DonationEvent?>((transaction) async {
        // Find the valid code
        final codeQuery = await _firestore
            .collection('valid_codes')
            .where('code', isEqualTo: code)
            .where('usedByUid', isNull: true)
            .where('expiresAt', isGreaterThan: Timestamp.now())
            .limit(1)
            .get();

        if (codeQuery.docs.isEmpty) {
          throw Exception('Invalid or expired code');
        }

        final codeDoc = codeQuery.docs.first;
        final validCode = ValidCode.fromJson(codeDoc.data());

        // Check if code is for the correct centre
        if (validCode.centreId != centreId) {
          throw Exception('Code not valid for this centre');
        }

        // Mark code as used
        transaction.update(codeDoc.reference, {
          'usedByUid': uid,
          'usedAt': Timestamp.now(),
        });

        // Create donation event
        final donationEvent = DonationEvent(
          id: _uuid.v4(),
          uid: uid,
          centreId: centreId,
          code: code,
          donatedAt: DateTime.now(),
          verified: true,
        );

        // Store donation event
        transaction.set(
          _firestore.collection('donation_events').doc(donationEvent.id),
          donationEvent.toJson(),
        );

        return donationEvent;
      });
    } catch (e) {
      print('Error validating code: $e');
      return null;
    }
  }

  /// Checks if a code exists and its status
  Future<Map<String, dynamic>> checkCodeStatus(String code) async {
    try {
      // HARDCODED TESTING CODE: BLD04Q0RWG is always valid for testing
      if (code == 'BLD04Q0RWG') {
        return {
          'exists': true,
          'valid': true,
          'message': 'Test code is always valid',
          'centreId': 'test', // Can be used at any centre
          'isTestCode': true,
        };
      }

      final querySnapshot = await _firestore
          .collection('valid_codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'exists': false, 'message': 'Code not found'};
      }

      final validCode = ValidCode.fromJson(querySnapshot.docs.first.data());

      if (validCode.usedByUid != null) {
        return {
          'exists': true,
          'used': true,
          'message': 'Code already used',
          'usedAt': validCode.usedAt?.toIso8601String(),
        };
      }

      if (validCode.expiresAt.isBefore(DateTime.now())) {
        return {
          'exists': true,
          'expired': true,
          'message': 'Code has expired',
        };
      }

      return {
        'exists': true,
        'valid': true,
        'message': 'Code is valid',
        'centreId': validCode.centreId,
      };
    } catch (e) {
      return {'exists': false, 'message': 'Error checking code: $e'};
    }
  }

  /// Get user's donation history
  Stream<List<DonationEvent>> getUserDonationHistory(String uid) {
    return _firestore
        .collection('donation_events')
        .where('uid', isEqualTo: uid)
        .orderBy('donatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DonationEvent.fromJson(doc.data()))
            .toList());
  }

  /// Get recent donations for leaderboard
  Future<List<DonationEvent>> getRecentDonations({
    int days = 7,
    int limit = 10,
  }) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    final querySnapshot = await _firestore
        .collection('donation_events')
        .where('donatedAt', isGreaterThan: Timestamp.fromDate(cutoffDate))
        .orderBy('donatedAt', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => DonationEvent.fromJson(doc.data()))
        .toList();
  }

  /// For demo/testing: Create valid codes (normally done by staff)
  Future<ValidCode> createValidCode({
    required String centreId,
    int validHours = 24,
  }) async {
    final code = _generateCode();
    final validCode = ValidCode(
      code: code,
      centreId: centreId,
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(hours: validHours)),
    );

    await _firestore
        .collection('valid_codes')
        .doc(code)
        .set(validCode.toJson());

    return validCode;
  }

  /// Get the hardcoded test code for testing purposes
  String getTestCode() {
    return 'BLD04Q0RWG';
  }

  String _generateCode() {
    // Generate a 6-digit alphanumeric code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var result = '';
    
    for (int i = 0; i < 6; i++) {
      result += chars[(random + i) % chars.length];
    }
    
    return result;
  }
}
