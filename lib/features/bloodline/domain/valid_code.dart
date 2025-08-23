import 'package:freezed_annotation/freezed_annotation.dart';

part 'valid_code.freezed.dart';
part 'valid_code.g.dart';

@freezed
class ValidCode with _$ValidCode {
  const factory ValidCode({
    required String code,
    required String centreId,
    required DateTime generatedAt,
    required DateTime expiresAt,
    String? usedByUid,
    DateTime? usedAt,
  }) = _ValidCode;

  factory ValidCode.fromJson(Map<String, dynamic> json) =>
      _$ValidCodeFromJson(json);
}
