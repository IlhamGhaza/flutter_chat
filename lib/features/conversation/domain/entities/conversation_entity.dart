class ConversationEntity {
  final int id;
  final int participantId;
  final String participantName;
  final dynamic participantPhoto;
  final String lastMessage;
  final DateTime lastMessageTime;

  ConversationEntity(
      {required this.id,
      required this.participantId,
      required this.participantName,
      required this.participantPhoto,
      required this.lastMessage,
      required this.lastMessageTime});
}
