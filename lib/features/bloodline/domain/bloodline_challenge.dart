import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloodline_challenge.freezed.dart';
part 'bloodline_challenge.g.dart';

@freezed
class BloodlineChallenge with _$BloodlineChallenge {
  const factory BloodlineChallenge({
    required String id,
    required String userAUid,
    required String userBUid,
    required DateTime createdAt,
    required DateTime lastChainEventAt,
    @Default(0) int streakLength,
    String? leaderUid,
    @Default(0) int nomineesCount,
    @Default('active') String status, // 'active' | 'ended'
  }) = _BloodlineChallenge;

  factory BloodlineChallenge.fromJson(Map<String, dynamic> json) =>
      _$BloodlineChallengeFromJson(json);
}
