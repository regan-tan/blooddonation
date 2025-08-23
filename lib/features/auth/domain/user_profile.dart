import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String displayName,
    required int age,
    String? school,
    String? bloodType,
    String? photoUrl,
    required DateTime createdAt,
    @Default(0) int totalLivesImpacted,
    @Default(0) int longestStreak,
    String? currentChallengeId,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
