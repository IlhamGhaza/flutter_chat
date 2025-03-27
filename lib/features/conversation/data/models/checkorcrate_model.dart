class CheckOrCreateConversationResponse {
  final int conversationId;
  final int participantId;
  final String participantName;
  final String participantPhoto;

  CheckOrCreateConversationResponse({
    required this.conversationId,
    required this.participantId,
    required this.participantName,
    required this.participantPhoto,
  });

  factory CheckOrCreateConversationResponse.fromJson(
      Map<String, dynamic> json) {
    return CheckOrCreateConversationResponse(
      conversationId: json['conversationid'],
      participantId: json['participant_id'],
      participantName: json['participant_name'],
      participantPhoto: json['participant_photo'],
    );
  }
}
