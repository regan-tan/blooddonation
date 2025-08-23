// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupBookingImpl _$$GroupBookingImplFromJson(Map<String, dynamic> json) =>
    _$GroupBookingImpl(
      id: json['id'] as String,
      centreId: json['centreId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      createdByUid: json['createdByUid'] as String,
      attendees: (json['attendees'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      rsvps: (json['rsvps'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GroupBookingImplToJson(_$GroupBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'centreId': instance.centreId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'createdByUid': instance.createdByUid,
      'attendees': instance.attendees,
      'rsvps': instance.rsvps,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
