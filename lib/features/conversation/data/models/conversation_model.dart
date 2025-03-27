import '../../domain/entities/conversation_entity.dart';


class ConversationModel extends ConversationEntity {
  ConversationModel(
      {required super.id,
      required super.participantId,
      required super.participantName,
      required super.participantPhoto,
      required super.lastMessage,
      required super.lastMessageTime});
      
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversationid'],
      participantId: json['participant_id'],
      participantName: json['participant_name'],
      participantPhoto: json['participant_photo'],
      lastMessage: json['last_message'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
    );
  }
}
