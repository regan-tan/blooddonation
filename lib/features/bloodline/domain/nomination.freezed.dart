// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nomination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Nomination _$NominationFromJson(Map<String, dynamic> json) {
  return _Nomination.fromJson(json);
}

/// @nodoc
mixin _$Nomination {
  String get id => throw _privateConstructorUsedError;
  String get challengeId => throw _privateConstructorUsedError;
  String get inviterUid => throw _privateConstructorUsedError;
  String get inviteeContact =>
      throw _privateConstructorUsedError; // email or phone
  String get inviteLink => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'sent' | 'joined' | 'donated'
  String? get donationEventId => throw _privateConstructorUsedError;

  /// Serializes this Nomination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Nomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NominationCopyWith<Nomination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NominationCopyWith<$Res> {
  factory $NominationCopyWith(
          Nomination value, $Res Function(Nomination) then) =
      _$NominationCopyWithImpl<$Res, Nomination>;
  @useResult
  $Res call(
      {String id,
      String challengeId,
      String inviterUid,
      String inviteeContact,
      String inviteLink,
      String status,
      String? donationEventId});
}

/// @nodoc
class _$NominationCopyWithImpl<$Res, $Val extends Nomination>
    implements $NominationCopyWith<$Res> {
  _$NominationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Nomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? challengeId = null,
    Object? inviterUid = null,
    Object? inviteeContact = null,
    Object? inviteLink = null,
    Object? status = null,
    Object? donationEventId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      challengeId: null == challengeId
          ? _value.challengeId
          : challengeId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterUid: null == inviterUid
          ? _value.inviterUid
          : inviterUid // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeContact: null == inviteeContact
          ? _value.inviteeContact
          : inviteeContact // ignore: cast_nullable_to_non_nullable
              as String,
      inviteLink: null == inviteLink
          ? _value.inviteLink
          : inviteLink // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      donationEventId: freezed == donationEventId
          ? _value.donationEventId
          : donationEventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NominationImplCopyWith<$Res>
    implements $NominationCopyWith<$Res> {
  factory _$$NominationImplCopyWith(
          _$NominationImpl value, $Res Function(_$NominationImpl) then) =
      __$$NominationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String challengeId,
      String inviterUid,
      String inviteeContact,
      String inviteLink,
      String status,
      String? donationEventId});
}

/// @nodoc
class __$$NominationImplCopyWithImpl<$Res>
    extends _$NominationCopyWithImpl<$Res, _$NominationImpl>
    implements _$$NominationImplCopyWith<$Res> {
  __$$NominationImplCopyWithImpl(
      _$NominationImpl _value, $Res Function(_$NominationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Nomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? challengeId = null,
    Object? inviterUid = null,
    Object? inviteeContact = null,
    Object? inviteLink = null,
    Object? status = null,
    Object? donationEventId = freezed,
  }) {
    return _then(_$NominationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      challengeId: null == challengeId
          ? _value.challengeId
          : challengeId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterUid: null == inviterUid
          ? _value.inviterUid
          : inviterUid // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeContact: null == inviteeContact
          ? _value.inviteeContact
          : inviteeContact // ignore: cast_nullable_to_non_nullable
              as String,
      inviteLink: null == inviteLink
          ? _value.inviteLink
          : inviteLink // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      donationEventId: freezed == donationEventId
          ? _value.donationEventId
          : donationEventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NominationImpl implements _Nomination {
  const _$NominationImpl(
      {required this.id,
      required this.challengeId,
      required this.inviterUid,
      required this.inviteeContact,
      required this.inviteLink,
      this.status = 'sent',
      this.donationEventId});

  factory _$NominationImpl.fromJson(Map<String, dynamic> json) =>
      _$$NominationImplFromJson(json);

  @override
  final String id;
  @override
  final String challengeId;
  @override
  final String inviterUid;
  @override
  final String inviteeContact;
// email or phone
  @override
  final String inviteLink;
  @override
  @JsonKey()
  final String status;
// 'sent' | 'joined' | 'donated'
  @override
  final String? donationEventId;

  @override
  String toString() {
    return 'Nomination(id: $id, challengeId: $challengeId, inviterUid: $inviterUid, inviteeContact: $inviteeContact, inviteLink: $inviteLink, status: $status, donationEventId: $donationEventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NominationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.challengeId, challengeId) ||
                other.challengeId == challengeId) &&
            (identical(other.inviterUid, inviterUid) ||
                other.inviterUid == inviterUid) &&
            (identical(other.inviteeContact, inviteeContact) ||
                other.inviteeContact == inviteeContact) &&
            (identical(other.inviteLink, inviteLink) ||
                other.inviteLink == inviteLink) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.donationEventId, donationEventId) ||
                other.donationEventId == donationEventId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, challengeId, inviterUid,
      inviteeContact, inviteLink, status, donationEventId);

  /// Create a copy of Nomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NominationImplCopyWith<_$NominationImpl> get copyWith =>
      __$$NominationImplCopyWithImpl<_$NominationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NominationImplToJson(
      this,
    );
  }
}

abstract class _Nomination implements Nomination {
  const factory _Nomination(
      {required final String id,
      required final String challengeId,
      required final String inviterUid,
      required final String inviteeContact,
      required final String inviteLink,
      final String status,
      final String? donationEventId}) = _$NominationImpl;

  factory _Nomination.fromJson(Map<String, dynamic> json) =
      _$NominationImpl.fromJson;

  @override
  String get id;
  @override
  String get challengeId;
  @override
  String get inviterUid;
  @override
  String get inviteeContact; // email or phone
  @override
  String get inviteLink;
  @override
  String get status; // 'sent' | 'joined' | 'donated'
  @override
  String? get donationEventId;

  /// Create a copy of Nomination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NominationImplCopyWith<_$NominationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
