import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_booking.freezed.dart';
part 'group_booking.g.dart';

@freezed
class GroupBooking with _$GroupBooking {
  const factory GroupBooking({
    required String id,
    required String centreId,
    required DateTime date,
    required String startTime, // e.g., "09:00"
    required String createdByUid,
    @Default(<String>[]) List<String> attendees,
    @Default(<String, String>{}) Map<String, String> rsvps, // uid: 'yes'|'no'|'maybe'
    String? notes,
    required DateTime createdAt,
  }) = _GroupBooking;

  factory GroupBooking.fromJson(Map<String, dynamic> json) =>
      _$GroupBookingFromJson(json);
}
