class DonationEvent {
  final String id;
  final String uid;
  final String centreId;
  final String code;
  final DateTime donatedAt;
  final bool verified;

  const DonationEvent({
    required this.id,
    required this.uid,
    required this.centreId,
    required this.code,
    required this.donatedAt,
    this.verified = true,
  });

  factory DonationEvent.fromJson(Map<String, dynamic> json) {
    return DonationEvent(
      id: json['id'] as String,
      uid: json['uid'] as String,
      centreId: json['centreId'] as String,
      code: json['code'] as String,
      donatedAt: DateTime.parse(json['donatedAt'] as String),
      verified: json['verified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'centreId': centreId,
      'code': code,
      'donatedAt': donatedAt.toIso8601String(),
      'verified': verified,
    };
  }
}
