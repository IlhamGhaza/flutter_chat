class ConversationEntity {
  final String id;
  final String participantId;
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
