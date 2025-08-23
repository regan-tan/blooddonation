import 'package:freezed_annotation/freezed_annotation.dart';

part 'nomination.freezed.dart';
part 'nomination.g.dart';

@freezed
class Nomination with _$Nomination {
  const factory Nomination({
    required String id,
    required String challengeId,
    required String inviterUid,
    required String inviteeContact, // email or phone
    required String inviteLink,
    @Default('sent') String status, // 'sent' | 'joined' | 'donated'
    String? donationEventId,
  }) = _Nomination;

  factory Nomination.fromJson(Map<String, dynamic> json) =>
      _$NominationFromJson(json);
}
