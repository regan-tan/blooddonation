import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../domain/group_booking.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Create a new group booking
  Future<GroupBooking> createGroupBooking({
    required String centreId,
    required DateTime date,
    required String startTime,
    required String createdByUid,
    List<String> initialAttendees = const [],
    String? notes,
  }) async {
    final booking = GroupBooking(
      id: _uuid.v4(),
      centreId: centreId,
      date: date,
      startTime: startTime,
      createdByUid: createdByUid,
      attendees: [createdByUid, ...initialAttendees],
      rsvps: {createdByUid: 'yes'},
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('group_bookings')
        .doc(booking.id)
        .set(booking.toJson());

    return booking;
  }

  /// Get a booking by ID
  Future<GroupBooking?> getBookingById(String bookingId) async {
    final doc = await _firestore
        .collection('group_bookings')
        .doc(bookingId)
        .get();

    if (!doc.exists) return null;
    return GroupBooking.fromJson(doc.data()!);
  }

  /// Get user's bookings
  Stream<List<GroupBooking>> getUserBookings(String uid) {
    try {
      return _firestore
          .collection('group_bookings')
          .where('attendees', arrayContains: uid)
          .snapshots()
          .map((snapshot) {
            final bookings = snapshot.docs
                .map((doc) => GroupBooking.fromJson(doc.data()))
                .toList();
            
            // Sort locally instead of using orderBy to avoid index requirements
            bookings.sort((a, b) => a.date.compareTo(b.date));
            return bookings;
          });
    } catch (e) {
      // Return empty stream if there's an error
      return Stream.value(<GroupBooking>[]);
    }
  }

  /// Update RSVP status
  Future<void> updateRSVP({
    required String bookingId,
    required String uid,
    required String rsvpStatus, // 'yes', 'no', 'maybe'
  }) async {
    await _firestore.collection('group_bookings').doc(bookingId).update({
      'rsvps.$uid': rsvpStatus,
    });
  }

  /// Add attendee to booking
  Future<void> addAttendee({
    required String bookingId,
    required String uid,
  }) async {
    await _firestore.collection('group_bookings').doc(bookingId).update({
      'attendees': FieldValue.arrayUnion([uid]),
      'rsvps.$uid': 'maybe', // Default to maybe until they confirm
    });
  }

  /// Remove attendee from booking
  Future<void> removeAttendee({
    required String bookingId,
    required String uid,
  }) async {
    final batch = _firestore.batch();
    
    final bookingRef = _firestore.collection('group_bookings').doc(bookingId);
    
    // Remove from attendees array
    batch.update(bookingRef, {
      'attendees': FieldValue.arrayRemove([uid]),
    });

    // Remove RSVP entry
    batch.update(bookingRef, {
      'rsvps.$uid': FieldValue.delete(),
    });

    await batch.commit();
  }

  /// Get bookings for a specific centre and date
  Future<List<GroupBooking>> getBookingsForCentreAndDate({
    required String centreId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final querySnapshot = await _firestore
        .collection('group_bookings')
        .where('centreId', isEqualTo: centreId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('date')
        .orderBy('startTime')
        .get();

    return querySnapshot.docs
        .map((doc) => GroupBooking.fromJson(doc.data()))
        .toList();
  }

  /// Update booking notes
  Future<void> updateBookingNotes({
    required String bookingId,
    required String notes,
  }) async {
    await _firestore.collection('group_bookings').doc(bookingId).update({
      'notes': notes,
    });
  }

  /// Delete a booking (only by creator)
  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('group_bookings').doc(bookingId).delete();
  }

  /// Get upcoming bookings across all users (for admin/stats)
  Future<List<GroupBooking>> getUpcomingBookings({
    int limit = 20,
  }) async {
    final now = DateTime.now();
    
    final querySnapshot = await _firestore
        .collection('group_bookings')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('date')
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => GroupBooking.fromJson(doc.data()))
        .toList();
  }

  /// Generate available time slots for a centre and date
  List<String> generateAvailableTimeSlots({
    required Map<String, dynamic> openingHours,
    required String dayOfWeek,
    required List<GroupBooking> existingBookings,
    int slotDurationMinutes = 30,
  }) {
    final dayHours = openingHours[dayOfWeek] as List<dynamic>?;
    if (dayHours == null || dayHours.isEmpty) {
      return []; // Centre closed on this day
    }

    final availableSlots = <String>[];
    
    for (final hours in dayHours) {
      final startTime = hours['start'] as String;
      final endTime = hours['end'] as String;
      
      final startMinutes = _timeToMinutes(startTime);
      final endMinutes = _timeToMinutes(endTime);
      
      for (int minutes = startMinutes; 
           minutes < endMinutes; 
           minutes += slotDurationMinutes) {
        final timeSlot = _minutesToTime(minutes);
        
        // Check if this slot is already booked
        final isBooked = existingBookings
            .any((booking) => booking.startTime == timeSlot);
        
        if (!isBooked) {
          availableSlots.add(timeSlot);
        }
      }
    }
    
    return availableSlots;
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String _minutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}
