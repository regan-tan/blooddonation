class Nomination {
  final String id;
  final String challengeId;
  final String inviterUid;
  final String inviteeContact;
  final String inviteLink;
  final String status;
  final String? donationEventId;

  const Nomination({
    required this.id,
    required this.challengeId,
    required this.inviterUid,
    required this.inviteeContact,
    required this.inviteLink,
    this.status = 'sent',
    this.donationEventId,
  });

  factory Nomination.fromJson(Map<String, dynamic> json) {
    return Nomination(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      inviterUid: json['inviterUid'] as String,
      inviteeContact: json['inviteeContact'] as String,
      inviteLink: json['inviteLink'] as String,
      status: json['status'] as String? ?? 'sent',
      donationEventId: json['donationEventId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'inviterUid': inviterUid,
      'inviteeContact': inviteeContact,
      'inviteLink': inviteLink,
      'status': status,
      'donationEventId': donationEventId,
    };
  }
}
