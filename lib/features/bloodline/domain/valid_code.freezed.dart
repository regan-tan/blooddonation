// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'valid_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidCode _$ValidCodeFromJson(Map<String, dynamic> json) {
  return _ValidCode.fromJson(json);
}

/// @nodoc
mixin _$ValidCode {
  String get code => throw _privateConstructorUsedError;
  String get centreId => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String? get usedByUid => throw _privateConstructorUsedError;
  DateTime? get usedAt => throw _privateConstructorUsedError;

  /// Serializes this ValidCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValidCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidCodeCopyWith<ValidCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidCodeCopyWith<$Res> {
  factory $ValidCodeCopyWith(ValidCode value, $Res Function(ValidCode) then) =
      _$ValidCodeCopyWithImpl<$Res, ValidCode>;
  @useResult
  $Res call(
      {String code,
      String centreId,
      DateTime generatedAt,
      DateTime expiresAt,
      String? usedByUid,
      DateTime? usedAt});
}

/// @nodoc
class _$ValidCodeCopyWithImpl<$Res, $Val extends ValidCode>
    implements $ValidCodeCopyWith<$Res> {
  _$ValidCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? centreId = null,
    Object? generatedAt = null,
    Object? expiresAt = null,
    Object? usedByUid = freezed,
    Object? usedAt = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedByUid: freezed == usedByUid
          ? _value.usedByUid
          : usedByUid // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidCodeImplCopyWith<$Res>
    implements $ValidCodeCopyWith<$Res> {
  factory _$$ValidCodeImplCopyWith(
          _$ValidCodeImpl value, $Res Function(_$ValidCodeImpl) then) =
      __$$ValidCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String centreId,
      DateTime generatedAt,
      DateTime expiresAt,
      String? usedByUid,
      DateTime? usedAt});
}

/// @nodoc
class __$$ValidCodeImplCopyWithImpl<$Res>
    extends _$ValidCodeCopyWithImpl<$Res, _$ValidCodeImpl>
    implements _$$ValidCodeImplCopyWith<$Res> {
  __$$ValidCodeImplCopyWithImpl(
      _$ValidCodeImpl _value, $Res Function(_$ValidCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? centreId = null,
    Object? generatedAt = null,
    Object? expiresAt = null,
    Object? usedByUid = freezed,
    Object? usedAt = freezed,
  }) {
    return _then(_$ValidCodeImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      centreId: null == centreId
          ? _value.centreId
          : centreId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedByUid: freezed == usedByUid
          ? _value.usedByUid
          : usedByUid // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidCodeImpl implements _ValidCode {
  const _$ValidCodeImpl(
      {required this.code,
      required this.centreId,
      required this.generatedAt,
      required this.expiresAt,
      this.usedByUid,
      this.usedAt});

  factory _$ValidCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidCodeImplFromJson(json);

  @override
  final String code;
  @override
  final String centreId;
  @override
  final DateTime generatedAt;
  @override
  final DateTime expiresAt;
  @override
  final String? usedByUid;
  @override
  final DateTime? usedAt;

  @override
  String toString() {
    return 'ValidCode(code: $code, centreId: $centreId, generatedAt: $generatedAt, expiresAt: $expiresAt, usedByUid: $usedByUid, usedAt: $usedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidCodeImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.centreId, centreId) ||
                other.centreId == centreId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.usedByUid, usedByUid) ||
                other.usedByUid == usedByUid) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, code, centreId, generatedAt, expiresAt, usedByUid, usedAt);

  /// Create a copy of ValidCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidCodeImplCopyWith<_$ValidCodeImpl> get copyWith =>
      __$$ValidCodeImplCopyWithImpl<_$ValidCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidCodeImplToJson(
      this,
    );
  }
}

abstract class _ValidCode implements ValidCode {
  const factory _ValidCode(
      {required final String code,
      required final String centreId,
      required final DateTime generatedAt,
      required final DateTime expiresAt,
      final String? usedByUid,
      final DateTime? usedAt}) = _$ValidCodeImpl;

  factory _ValidCode.fromJson(Map<String, dynamic> json) =
      _$ValidCodeImpl.fromJson;

  @override
  String get code;
  @override
  String get centreId;
  @override
  DateTime get generatedAt;
  @override
  DateTime get expiresAt;
  @override
  String? get usedByUid;
  @override
  DateTime? get usedAt;

  /// Create a copy of ValidCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidCodeImplCopyWith<_$ValidCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
