// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupBooking _$GroupBookingFromJson(Map<String, dynamic> json) {
  return _GroupBooking.fromJson(json);
}

/// @nodoc
mixin _$GroupBooking {
  String get id => throw _privateConstructorUsedError;
  String get centreId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError; // e.g., "09:00"
  String get createdByUid => throw _privateConstructorUsedError;
  List<String> get attendees => throw _privateConstructorUsedError;
  Map<String, String> get rsvps =>
      throw _privateConstructorUsedError; // uid: 'yes'|'no'|'maybe'
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GroupBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupBookingCopyWith<GroupBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupBookingCopyWith<$Res> {
  factory $GroupBookingCopyWith(
          GroupBooking value, $Res Function(GroupBooking) then) =
      _$GroupBookingCopyWithImpl<$Res, GroupBooking>;
  @useResult
  $Res call(
      {String id,
      String centreId,
      DateTime date,
      String startTime,
      String createdByUid,
      List<String> attendees,
      Map<String, String> rsvps,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class _$GroupBookingCopyWithImpl<$Res, $Val extends GroupBooking>
    implements $GroupBookingCopyWith<$Res> {
  _$GroupBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? centreId = null,
    Object? date = null,
    Object? startTime = null,
    Object? createdByUid = null,
    Object? attendees = null,
    Object? rsvps = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      createdByUid: null == createdByUid
          ? _value.createdByUid
          : createdByUid // ignore: cast_nullable_to_non_nullable
              as String,
      attendees: null == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rsvps: null == rsvps
          ? _value.rsvps
          : rsvps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupBookingImplCopyWith<$Res>
    implements $GroupBookingCopyWith<$Res> {
  factory _$$GroupBookingImplCopyWith(
          _$GroupBookingImpl value, $Res Function(_$GroupBookingImpl) then) =
      __$$GroupBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String centreId,
      DateTime date,
      String startTime,
      String createdByUid,
      List<String> attendees,
      Map<String, String> rsvps,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class __$$GroupBookingImplCopyWithImpl<$Res>
    extends _$GroupBookingCopyWithImpl<$Res, _$GroupBookingImpl>
    implements _$$GroupBookingImplCopyWith<$Res> {
  __$$GroupBookingImplCopyWithImpl(
      _$GroupBookingImpl _value, $Res Function(_$GroupBookingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? centreId = null,
    Object? date = null,
    Object? startTime = null,
    Object? createdByUid = null,
    Object? attendees = null,
    Object? rsvps = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$GroupBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      createdByUid: null == createdByUid
          ? _value.createdByUid
          : createdByUid // ignore: cast_nullable_to_non_nullable
              as String,
      attendees: null == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rsvps: null == rsvps
          ? _value._rsvps
          : rsvps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupBookingImpl implements _GroupBooking {
  const _$GroupBookingImpl(
      {required this.id,
      required this.centreId,
      required this.date,
      required this.startTime,
      required this.createdByUid,
      final List<String> attendees = const <String>[],
      final Map<String, String> rsvps = const <String, String>{},
      this.notes,
      required this.createdAt})
      : _attendees = attendees,
        _rsvps = rsvps;

  factory _$GroupBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String centreId;
  @override
  final DateTime date;
  @override
  final String startTime;
// e.g., "09:00"
  @override
  final String createdByUid;
  final List<String> _attendees;
  @override
  @JsonKey()
  List<String> get attendees {
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attendees);
  }

  final Map<String, String> _rsvps;
  @override
  @JsonKey()
  Map<String, String> get rsvps {
    if (_rsvps is EqualUnmodifiableMapView) return _rsvps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rsvps);
  }

// uid: 'yes'|'no'|'maybe'
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'GroupBooking(id: $id, centreId: $centreId, date: $date, startTime: $startTime, createdByUid: $createdByUid, attendees: $attendees, rsvps: $rsvps, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.centreId, centreId) ||
                other.centreId == centreId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.createdByUid, createdByUid) ||
                other.createdByUid == createdByUid) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees) &&
            const DeepCollectionEquality().equals(other._rsvps, _rsvps) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      centreId,
      date,
      startTime,
      createdByUid,
      const DeepCollectionEquality().hash(_attendees),
      const DeepCollectionEquality().hash(_rsvps),
      notes,
      createdAt);

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupBookingImplCopyWith<_$GroupBookingImpl> get copyWith =>
      __$$GroupBookingImplCopyWithImpl<_$GroupBookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupBookingImplToJson(
      this,
    );
  }
}

abstract class _GroupBooking implements GroupBooking {
  const factory _GroupBooking(
      {required final String id,
      required final String centreId,
      required final DateTime date,
      required final String startTime,
      required final String createdByUid,
      final List<String> attendees,
      final Map<String, String> rsvps,
      final String? notes,
      required final DateTime createdAt}) = _$GroupBookingImpl;

  factory _GroupBooking.fromJson(Map<String, dynamic> json) =
      _$GroupBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get centreId;
  @override
  DateTime get date;
  @override
  String get startTime; // e.g., "09:00"
  @override
  String get createdByUid;
  @override
  List<String> get attendees;
  @override
  Map<String, String> get rsvps; // uid: 'yes'|'no'|'maybe'
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupBookingImplCopyWith<_$GroupBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
