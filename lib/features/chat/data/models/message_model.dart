import '../../domain/entities/message_entity.dart';
import 'package:intl/intl.dart';

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
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      conversationId: json['conversationId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'conversationId': conversationId,
      'createdAt': formatter.format(createdAt!),
    };
  }
}
