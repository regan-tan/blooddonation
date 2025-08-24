class Friend {
  final String id;
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime addedAt;
  final String status; // 'pending', 'accepted', 'blocked'

  const Friend({
    required this.id,
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.addedAt,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'addedAt': addedAt.toIso8601String(),
      'status': status,
    };
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
      status: json['status'] as String,
    );
  }

  Friend copyWith({
    String? id,
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? addedAt,
    String? status,
  }) {
    return Friend(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      addedAt: addedAt ?? this.addedAt,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Friend && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Friend(id: $id, email: $email, displayName: $displayName, status: $status)';
  }
}
