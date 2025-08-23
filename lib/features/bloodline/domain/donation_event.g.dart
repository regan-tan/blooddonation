// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DonationEventImpl _$$DonationEventImplFromJson(Map<String, dynamic> json) =>
    _$DonationEventImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      centreId: json['centreId'] as String,
      code: json['code'] as String,
      donatedAt: DateTime.parse(json['donatedAt'] as String),
      verified: json['verified'] as bool? ?? true,
    );

Map<String, dynamic> _$$DonationEventImplToJson(_$DonationEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'centreId': instance.centreId,
      'code': instance.code,
      'donatedAt': instance.donatedAt.toIso8601String(),
      'verified': instance.verified,
    };
