import 'package:flutter_chat/features/chat/domain/entities/message_entity.dart';

import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository{
  final MessageRemoteDatasource messageRemoteDatasource;

  MessageRepositoryImpl({required this.messageRemoteDatasource});
  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async{
    return await messageRemoteDatasource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}