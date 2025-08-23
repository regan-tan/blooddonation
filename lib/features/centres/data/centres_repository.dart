import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/donation_centre.dart';

class CentresRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DonationCentre>> getAllCentres() async {
    // First try to get from Firestore (for real-time updates)
    try {
      final querySnapshot = await _firestore.collection('centres').get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => DonationCentre.fromJson(doc.data()))
            .toList();
      }
    } catch (e) {
      // If Firestore fails, fall back to local asset
      print('Firestore centres not available, using local data: $e');
    }

    // Fall back to local asset file
    return await _getCentresFromAsset();
  }

  Future<List<DonationCentre>> _getCentresFromAsset() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/centres/centres_seed.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList
          .map((json) => DonationCentre.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading centres from asset: $e');
      return [];
    }
  }

  Future<DonationCentre?> getCentreById(String id) async {
    try {
      final doc = await _firestore.collection('centres').doc(id).get();
      if (doc.exists) {
        return DonationCentre.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error getting centre from Firestore: $e');
    }

    // Fall back to searching in local asset
    final centres = await _getCentresFromAsset();
    try {
      return centres.firstWhere((centre) => centre.id == id);
    } catch (e) {
      return null;
    }
  }

  Stream<List<DonationCentre>> getCentresStream() {
    return _firestore
        .collection('centres')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DonationCentre.fromJson(doc.data()))
            .toList())
        .handleError((error) {
          print('Error streaming centres: $error');
          return <DonationCentre>[];
        });
  }

  Future<List<DonationCentre>> searchCentres(String query) async {
    final allCentres = await getAllCentres();
    final lowercaseQuery = query.toLowerCase();
    
    return allCentres.where((centre) {
      return centre.name.toLowerCase().contains(lowercaseQuery) ||
             centre.address.toLowerCase().contains(lowercaseQuery) ||
             centre.type.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<DonationCentre>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  }) async {
    final allCentres = await getAllCentres();
    
    // Simple distance filtering (in a real app, you'd use geohash or similar)
    return allCentres.where((centre) {
      if (centre.lat == null || centre.lng == null) return false;
      
      final distance = _calculateDistance(lat, lng, centre.lat!, centre.lng!);
      return distance <= radiusKm;
    }).toList();
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Simplified distance calculation (Haversine formula would be more accurate)
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (3.14159 / 180);
    final double dLng = (lng2 - lng1) * (3.14159 / 180);
    
    final double a = 0.5 - 0.5 * (dLat.abs() + dLng.abs());
    return earthRadius * 2 * a.clamp(0.0, 1.0);
  }
}
