// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      age: (json['age'] as num).toInt(),
      school: json['school'] as String?,
      bloodType: json['bloodType'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalLivesImpacted: (json['totalLivesImpacted'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      currentChallengeId: json['currentChallengeId'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'age': instance.age,
      'school': instance.school,
      'bloodType': instance.bloodType,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalLivesImpacted': instance.totalLivesImpacted,
      'longestStreak': instance.longestStreak,
      'currentChallengeId': instance.currentChallengeId,
    };
