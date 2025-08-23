class UserProfile {
  final String uid;
  final String displayName;
  final int age;
  final String? school;
  final String? bloodType;
  final String? photoUrl;
  final DateTime createdAt;
  final int totalLivesImpacted;
  final int longestStreak;
  final String? currentChallengeId;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.age,
    this.school,
    this.bloodType,
    this.photoUrl,
    required this.createdAt,
    this.totalLivesImpacted = 0,
    this.longestStreak = 0,
    this.currentChallengeId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      age: json['age'] as int,
      school: json['school'] as String?,
      bloodType: json['bloodType'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalLivesImpacted: json['totalLivesImpacted'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      currentChallengeId: json['currentChallengeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'age': age,
      'school': school,
      'bloodType': bloodType,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'totalLivesImpacted': totalLivesImpacted,
      'longestStreak': longestStreak,
      'currentChallengeId': currentChallengeId,
    };
  }
}
