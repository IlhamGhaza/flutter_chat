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
      id: json['id'],
      participantId: json['participantId'],
      participantName: json['participantName'],
      participantPhoto: json['participantPhoto'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
    );
  }
}
