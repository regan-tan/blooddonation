class GroupBooking {
  final String id;
  final String centreId;
  final DateTime date;
  final String startTime;
  final String createdByUid;
  final List<String> attendees;
  final Map<String, String> rsvps;
  final String? notes;
  final DateTime createdAt;

  const GroupBooking({
    required this.id,
    required this.centreId,
    required this.date,
    required this.startTime,
    required this.createdByUid,
    this.attendees = const <String>[],
    this.rsvps = const <String, String>{},
    this.notes,
    required this.createdAt,
  });

  factory GroupBooking.fromJson(Map<String, dynamic> json) {
    return GroupBooking(
      id: json['id'] as String,
      centreId: json['centreId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      createdByUid: json['createdByUid'] as String,
      attendees: (json['attendees'] as List<dynamic>?)?.cast<String>() ?? <String>[],
      rsvps: (json['rsvps'] as Map<String, dynamic>?)?.cast<String, String>() ?? <String, String>{},
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'centreId': centreId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'createdByUid': createdByUid,
      'attendees': attendees,
      'rsvps': rsvps,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
