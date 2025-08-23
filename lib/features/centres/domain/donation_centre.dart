import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_centre.freezed.dart';
part 'donation_centre.g.dart';

@freezed
class DonationCentre with _$DonationCentre {
  const factory DonationCentre({
    required String id,
    required String name,
    required String type, // 'Blood Bank' | 'Mobile Drive'
    required String address,
    double? lat,
    double? lng,
    String? phone,
    required Map<String, List<OpeningHours>> openingHours,
    String? bookingUrl,
    required DateTime lastFetchedAt,
  }) = _DonationCentre;

  factory DonationCentre.fromJson(Map<String, dynamic> json) =>
      _$DonationCentreFromJson(json);
}

@freezed
class OpeningHours with _$OpeningHours {
  const factory OpeningHours({
    required String start, // e.g., "09:00"
    required String end,   // e.g., "18:00"
  }) = _OpeningHours;

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);
}
