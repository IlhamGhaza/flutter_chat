class ConversationEntity {
  final String id;
  final String participantName;
  String participant_photo;
  final String lastMessage;
  final DateTime lastMessageTime;

  ConversationEntity(
      {required this.id,
      required this.participantName,
      this.participant_photo = '',
      required this.lastMessage,
      required this.lastMessageTime});
}
