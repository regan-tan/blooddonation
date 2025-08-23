import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_event.freezed.dart';
part 'donation_event.g.dart';

@freezed
class DonationEvent with _$DonationEvent {
  const factory DonationEvent({
    required String id,
    required String uid,
    required String centreId,
    required String code,
    required DateTime donatedAt,
    @Default(true) bool verified,
  }) = _DonationEvent;

  factory DonationEvent.fromJson(Map<String, dynamic> json) =>
      _$DonationEventFromJson(json);
}
