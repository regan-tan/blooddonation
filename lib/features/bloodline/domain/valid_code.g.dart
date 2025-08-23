// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valid_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidCodeImpl _$$ValidCodeImplFromJson(Map<String, dynamic> json) =>
    _$ValidCodeImpl(
      code: json['code'] as String,
      centreId: json['centreId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      usedByUid: json['usedByUid'] as String?,
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
    );

Map<String, dynamic> _$$ValidCodeImplToJson(_$ValidCodeImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'centreId': instance.centreId,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'usedByUid': instance.usedByUid,
      'usedAt': instance.usedAt?.toIso8601String(),
    };
