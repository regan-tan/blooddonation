class BloodlineChallenge {
  final String id;
  final String userAUid;
  final String userBUid;
  final DateTime createdAt;
  final DateTime lastChainEventAt;
  final int streakLength;
  final String? leaderUid;
  final int nomineesCount;
  final String status;

  const BloodlineChallenge({
    required this.id,
    required this.userAUid,
    required this.userBUid,
    required this.createdAt,
    required this.lastChainEventAt,
    this.streakLength = 0,
    this.leaderUid,
    this.nomineesCount = 0,
    this.status = 'active',
  });

  factory BloodlineChallenge.fromJson(Map<String, dynamic> json) {
    return BloodlineChallenge(
      id: json['id'] as String,
      userAUid: json['userAUid'] as String,
      userBUid: json['userBUid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastChainEventAt: DateTime.parse(json['lastChainEventAt'] as String),
      streakLength: json['streakLength'] as int? ?? 0,
      leaderUid: json['leaderUid'] as String?,
      nomineesCount: json['nomineesCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userAUid': userAUid,
      'userBUid': userBUid,
      'createdAt': createdAt.toIso8601String(),
      'lastChainEventAt': lastChainEventAt.toIso8601String(),
      'streakLength': streakLength,
      'leaderUid': leaderUid,
      'nomineesCount': nomineesCount,
      'status': status,
    };
  }
}
