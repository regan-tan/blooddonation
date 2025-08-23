// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloodline_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BloodlineChallengeImpl _$$BloodlineChallengeImplFromJson(
        Map<String, dynamic> json) =>
    _$BloodlineChallengeImpl(
      id: json['id'] as String,
      userAUid: json['userAUid'] as String,
      userBUid: json['userBUid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastChainEventAt: DateTime.parse(json['lastChainEventAt'] as String),
      streakLength: (json['streakLength'] as num?)?.toInt() ?? 0,
      leaderUid: json['leaderUid'] as String?,
      nomineesCount: (json['nomineesCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
    );

Map<String, dynamic> _$$BloodlineChallengeImplToJson(
        _$BloodlineChallengeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userAUid': instance.userAUid,
      'userBUid': instance.userBUid,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastChainEventAt': instance.lastChainEventAt.toIso8601String(),
      'streakLength': instance.streakLength,
      'leaderUid': instance.leaderUid,
      'nomineesCount': instance.nomineesCount,
      'status': instance.status,
    };
