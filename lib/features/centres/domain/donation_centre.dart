class DonationCentre {
  final String id;
  final String name;
  final String type;
  final String address;
  final double? lat;
  final double? lng;
  final String? phone;
  final String? postDonationPhone;
  final Map<String, dynamic> donationTypes;
  final Map<String, dynamic>? transportation;
  final List<String>? notes;
  final String? bookingUrl;
  final DateTime lastFetchedAt;

  const DonationCentre({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.lat,
    this.lng,
    this.phone,
    this.postDonationPhone,
    required this.donationTypes,
    this.transportation,
    this.notes,
    this.bookingUrl,
    required this.lastFetchedAt,
  });

  factory DonationCentre.fromJson(Map<String, dynamic> json) {
    return DonationCentre(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      phone: json['phone'] as String?,
      postDonationPhone: json['postDonationPhone'] as String?,
      donationTypes: json['donationTypes'] as Map<String, dynamic>,
      transportation: json['transportation'] as Map<String, dynamic>?,
      notes: (json['notes'] as List<dynamic>?)?.cast<String>(),
      bookingUrl: json['bookingUrl'] as String?,
      lastFetchedAt: DateTime.parse(json['lastFetchedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'lat': lat,
      'lng': lng,
      'phone': phone,
      'postDonationPhone': postDonationPhone,
      'donationTypes': donationTypes,
      'transportation': transportation,
      'notes': notes,
      'bookingUrl': bookingUrl,
      'lastFetchedAt': lastFetchedAt.toIso8601String(),
    };
  }
}

class OpeningHours {
  final String start;
  final String end;

  const OpeningHours({
    required this.start,
    required this.end,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}
