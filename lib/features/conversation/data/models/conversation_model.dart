import '../../domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel(
      {required id,
      required participantName,
      super.participant_photo = '',
      required lastMessage,
      required lastMessageTime})
      : super(
            id: id,
            participantName: participantName,
            lastMessage: lastMessage,
            lastMessageTime: lastMessageTime);
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversation_id'],
      participantName: json['participant_name'],
      participant_photo: json['participant_photo'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
    );
  }
}
