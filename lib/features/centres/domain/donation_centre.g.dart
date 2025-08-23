// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_centre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DonationCentreImpl _$$DonationCentreImplFromJson(Map<String, dynamic> json) =>
    _$DonationCentreImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      openingHours: (json['openingHours'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => OpeningHours.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      bookingUrl: json['bookingUrl'] as String?,
      lastFetchedAt: DateTime.parse(json['lastFetchedAt'] as String),
    );

Map<String, dynamic> _$$DonationCentreImplToJson(
        _$DonationCentreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': instance.phone,
      'openingHours': instance.openingHours,
      'bookingUrl': instance.bookingUrl,
      'lastFetchedAt': instance.lastFetchedAt.toIso8601String(),
    };

_$OpeningHoursImpl _$$OpeningHoursImplFromJson(Map<String, dynamic> json) =>
    _$OpeningHoursImpl(
      start: json['start'] as String,
      end: json['end'] as String,
    );

Map<String, dynamic> _$$OpeningHoursImplToJson(_$OpeningHoursImpl instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
