import 'package:intl/intl.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required int id,
    required String content,
    required int senderId,
    required int conversationId,
    required DateTime createdAt,
  }) : super(
          id: id,
          content: content,
          senderId: senderId,
          conversationId: conversationId,
          createdAt: createdAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      content: json['content'] as String,
      senderId: json['sender_id'] as int,
      conversationId: json['conversation_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'conversation_id': conversationId,
      'created_at': formatter.format(createdAt!),
    };
  }
}
