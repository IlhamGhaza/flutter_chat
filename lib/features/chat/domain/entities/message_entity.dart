class MessageEntity {
  final int? id;
  final String? content;
  final int? senderId;
  final int? conversationId;
  final DateTime? createdAt;

  MessageEntity({required this.id, required this.content, required this.senderId, required this.conversationId, required this.createdAt});
}
