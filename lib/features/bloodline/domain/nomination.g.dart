// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NominationImpl _$$NominationImplFromJson(Map<String, dynamic> json) =>
    _$NominationImpl(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      inviterUid: json['inviterUid'] as String,
      inviteeContact: json['inviteeContact'] as String,
      inviteLink: json['inviteLink'] as String,
      status: json['status'] as String? ?? 'sent',
      donationEventId: json['donationEventId'] as String?,
    );

Map<String, dynamic> _$$NominationImplToJson(_$NominationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeId': instance.challengeId,
      'inviterUid': instance.inviterUid,
      'inviteeContact': instance.inviteeContact,
      'inviteLink': instance.inviteLink,
      'status': instance.status,
      'donationEventId': instance.donationEventId,
    };
