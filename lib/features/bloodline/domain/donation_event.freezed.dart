// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DonationEvent _$DonationEventFromJson(Map<String, dynamic> json) {
  return _DonationEvent.fromJson(json);
}

/// @nodoc
mixin _$DonationEvent {
  String get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get centreId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DateTime get donatedAt => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;

  /// Serializes this DonationEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DonationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DonationEventCopyWith<DonationEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonationEventCopyWith<$Res> {
  factory $DonationEventCopyWith(
          DonationEvent value, $Res Function(DonationEvent) then) =
      _$DonationEventCopyWithImpl<$Res, DonationEvent>;
  @useResult
  $Res call(
      {String id,
      String uid,
      String centreId,
      String code,
      DateTime donatedAt,
      bool verified});
}

/// @nodoc
class _$DonationEventCopyWithImpl<$Res, $Val extends DonationEvent>
    implements $DonationEventCopyWith<$Res> {
  _$DonationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DonationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? centreId = null,
    Object? code = null,
    Object? donatedAt = null,
    Object? verified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      donatedAt: null == donatedAt
          ? _value.donatedAt
          : donatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DonationEventImplCopyWith<$Res>
    implements $DonationEventCopyWith<$Res> {
  factory _$$DonationEventImplCopyWith(
          _$DonationEventImpl value, $Res Function(_$DonationEventImpl) then) =
      __$$DonationEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String uid,
      String centreId,
      String code,
      DateTime donatedAt,
      bool verified});
}

/// @nodoc
class __$$DonationEventImplCopyWithImpl<$Res>
    extends _$DonationEventCopyWithImpl<$Res, _$DonationEventImpl>
    implements _$$DonationEventImplCopyWith<$Res> {
  __$$DonationEventImplCopyWithImpl(
      _$DonationEventImpl _value, $Res Function(_$DonationEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of DonationEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? centreId = null,
    Object? code = null,
    Object? donatedAt = null,
    Object? verified = null,
  }) {
    return _then(_$DonationEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      donatedAt: null == donatedAt
          ? _value.donatedAt
          : donatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DonationEventImpl implements _DonationEvent {
  const _$DonationEventImpl(
      {required this.id,
      required this.uid,
      required this.centreId,
      required this.code,
      required this.donatedAt,
      this.verified = true});

  factory _$DonationEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonationEventImplFromJson(json);

  @override
  final String id;
  @override
  final String uid;
  @override
  final String centreId;
  @override
  final String code;
  @override
  final DateTime donatedAt;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'DonationEvent(id: $id, uid: $uid, centreId: $centreId, code: $code, donatedAt: $donatedAt, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonationEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.centreId, centreId) ||
                other.centreId == centreId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.donatedAt, donatedAt) ||
                other.donatedAt == donatedAt) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, uid, centreId, code, donatedAt, verified);

  /// Create a copy of DonationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DonationEventImplCopyWith<_$DonationEventImpl> get copyWith =>
      __$$DonationEventImplCopyWithImpl<_$DonationEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonationEventImplToJson(
      this,
    );
  }
}

abstract class _DonationEvent implements DonationEvent {
  const factory _DonationEvent(
      {required final String id,
      required final String uid,
      required final String centreId,
      required final String code,
      required final DateTime donatedAt,
      final bool verified}) = _$DonationEventImpl;

  factory _DonationEvent.fromJson(Map<String, dynamic> json) =
      _$DonationEventImpl.fromJson;

  @override
  String get id;
  @override
  String get uid;
  @override
  String get centreId;
  @override
  String get code;
  @override
  DateTime get donatedAt;
  @override
  bool get verified;

  /// Create a copy of DonationEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DonationEventImplCopyWith<_$DonationEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
