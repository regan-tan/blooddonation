class ValidCode {
  final String code;
  final String centreId;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final String? usedByUid;
  final DateTime? usedAt;

  const ValidCode({
    required this.code,
    required this.centreId,
    required this.generatedAt,
    required this.expiresAt,
    this.usedByUid,
    this.usedAt,
  });

  factory ValidCode.fromJson(Map<String, dynamic> json) {
    return ValidCode(
      code: json['code'] as String,
      centreId: json['centreId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      usedByUid: json['usedByUid'] as String?,
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'centreId': centreId,
      'generatedAt': generatedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'usedByUid': usedByUid,
      'usedAt': usedAt?.toIso8601String(),
    };
  }
}
