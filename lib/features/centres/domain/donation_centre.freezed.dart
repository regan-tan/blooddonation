// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation_centre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DonationCentre _$DonationCentreFromJson(Map<String, dynamic> json) {
  return _DonationCentre.fromJson(json);
}

/// @nodoc
mixin _$DonationCentre {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'Blood Bank' | 'Mobile Drive'
  String get address => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  Map<String, List<OpeningHours>> get openingHours =>
      throw _privateConstructorUsedError;
  String? get bookingUrl => throw _privateConstructorUsedError;
  DateTime get lastFetchedAt => throw _privateConstructorUsedError;

  /// Serializes this DonationCentre to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DonationCentre
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DonationCentreCopyWith<DonationCentre> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonationCentreCopyWith<$Res> {
  factory $DonationCentreCopyWith(
          DonationCentre value, $Res Function(DonationCentre) then) =
      _$DonationCentreCopyWithImpl<$Res, DonationCentre>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String address,
      double? lat,
      double? lng,
      String? phone,
      Map<String, List<OpeningHours>> openingHours,
      String? bookingUrl,
      DateTime lastFetchedAt});
}

/// @nodoc
class _$DonationCentreCopyWithImpl<$Res, $Val extends DonationCentre>
    implements $DonationCentreCopyWith<$Res> {
  _$DonationCentreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DonationCentre
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? address = null,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? phone = freezed,
    Object? openingHours = null,
    Object? bookingUrl = freezed,
    Object? lastFetchedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: null == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, List<OpeningHours>>,
      bookingUrl: freezed == bookingUrl
          ? _value.bookingUrl
          : bookingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFetchedAt: null == lastFetchedAt
          ? _value.lastFetchedAt
          : lastFetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DonationCentreImplCopyWith<$Res>
    implements $DonationCentreCopyWith<$Res> {
  factory _$$DonationCentreImplCopyWith(_$DonationCentreImpl value,
          $Res Function(_$DonationCentreImpl) then) =
      __$$DonationCentreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String address,
      double? lat,
      double? lng,
      String? phone,
      Map<String, List<OpeningHours>> openingHours,
      String? bookingUrl,
      DateTime lastFetchedAt});
}

/// @nodoc
class __$$DonationCentreImplCopyWithImpl<$Res>
    extends _$DonationCentreCopyWithImpl<$Res, _$DonationCentreImpl>
    implements _$$DonationCentreImplCopyWith<$Res> {
  __$$DonationCentreImplCopyWithImpl(
      _$DonationCentreImpl _value, $Res Function(_$DonationCentreImpl) _then)
      : super(_value, _then);

  /// Create a copy of DonationCentre
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? address = null,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? phone = freezed,
    Object? openingHours = null,
    Object? bookingUrl = freezed,
    Object? lastFetchedAt = null,
  }) {
    return _then(_$DonationCentreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: null == openingHours
          ? _value._openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, List<OpeningHours>>,
      bookingUrl: freezed == bookingUrl
          ? _value.bookingUrl
          : bookingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFetchedAt: null == lastFetchedAt
          ? _value.lastFetchedAt
          : lastFetchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DonationCentreImpl implements _DonationCentre {
  const _$DonationCentreImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.address,
      this.lat,
      this.lng,
      this.phone,
      required final Map<String, List<OpeningHours>> openingHours,
      this.bookingUrl,
      required this.lastFetchedAt})
      : _openingHours = openingHours;

  factory _$DonationCentreImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonationCentreImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
// 'Blood Bank' | 'Mobile Drive'
  @override
  final String address;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  final String? phone;
  final Map<String, List<OpeningHours>> _openingHours;
  @override
  Map<String, List<OpeningHours>> get openingHours {
    if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_openingHours);
  }

  @override
  final String? bookingUrl;
  @override
  final DateTime lastFetchedAt;

  @override
  String toString() {
    return 'DonationCentre(id: $id, name: $name, type: $type, address: $address, lat: $lat, lng: $lng, phone: $phone, openingHours: $openingHours, bookingUrl: $bookingUrl, lastFetchedAt: $lastFetchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonationCentreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality()
                .equals(other._openingHours, _openingHours) &&
            (identical(other.bookingUrl, bookingUrl) ||
                other.bookingUrl == bookingUrl) &&
            (identical(other.lastFetchedAt, lastFetchedAt) ||
                other.lastFetchedAt == lastFetchedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      address,
      lat,
      lng,
      phone,
      const DeepCollectionEquality().hash(_openingHours),
      bookingUrl,
      lastFetchedAt);

  /// Create a copy of DonationCentre
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DonationCentreImplCopyWith<_$DonationCentreImpl> get copyWith =>
      __$$DonationCentreImplCopyWithImpl<_$DonationCentreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonationCentreImplToJson(
      this,
    );
  }
}

abstract class _DonationCentre implements DonationCentre {
  const factory _DonationCentre(
      {required final String id,
      required final String name,
      required final String type,
      required final String address,
      final double? lat,
      final double? lng,
      final String? phone,
      required final Map<String, List<OpeningHours>> openingHours,
      final String? bookingUrl,
      required final DateTime lastFetchedAt}) = _$DonationCentreImpl;

  factory _DonationCentre.fromJson(Map<String, dynamic> json) =
      _$DonationCentreImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type; // 'Blood Bank' | 'Mobile Drive'
  @override
  String get address;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  String? get phone;
  @override
  Map<String, List<OpeningHours>> get openingHours;
  @override
  String? get bookingUrl;
  @override
  DateTime get lastFetchedAt;

  /// Create a copy of DonationCentre
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DonationCentreImplCopyWith<_$DonationCentreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return _OpeningHours.fromJson(json);
}

/// @nodoc
mixin _$OpeningHours {
  String get start => throw _privateConstructorUsedError; // e.g., "09:00"
  String get end => throw _privateConstructorUsedError;

  /// Serializes this OpeningHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpeningHoursCopyWith<OpeningHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpeningHoursCopyWith<$Res> {
  factory $OpeningHoursCopyWith(
          OpeningHours value, $Res Function(OpeningHours) then) =
      _$OpeningHoursCopyWithImpl<$Res, OpeningHours>;
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res, $Val extends OpeningHours>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpeningHoursImplCopyWith<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  factory _$$OpeningHoursImplCopyWith(
          _$OpeningHoursImpl value, $Res Function(_$OpeningHoursImpl) then) =
      __$$OpeningHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String start, String end});
}

/// @nodoc
class __$$OpeningHoursImplCopyWithImpl<$Res>
    extends _$OpeningHoursCopyWithImpl<$Res, _$OpeningHoursImpl>
    implements _$$OpeningHoursImplCopyWith<$Res> {
  __$$OpeningHoursImplCopyWithImpl(
      _$OpeningHoursImpl _value, $Res Function(_$OpeningHoursImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$OpeningHoursImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpeningHoursImpl implements _OpeningHours {
  const _$OpeningHoursImpl({required this.start, required this.end});

  factory _$OpeningHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpeningHoursImplFromJson(json);

  @override
  final String start;
// e.g., "09:00"
  @override
  final String end;

  @override
  String toString() {
    return 'OpeningHours(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpeningHoursImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      __$$OpeningHoursImplCopyWithImpl<_$OpeningHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpeningHoursImplToJson(
      this,
    );
  }
}

abstract class _OpeningHours implements OpeningHours {
  const factory _OpeningHours(
      {required final String start,
      required final String end}) = _$OpeningHoursImpl;

  factory _OpeningHours.fromJson(Map<String, dynamic> json) =
      _$OpeningHoursImpl.fromJson;

  @override
  String get start; // e.g., "09:00"
  @override
  String get end;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
