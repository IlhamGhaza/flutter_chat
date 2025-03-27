
import 'package:flutter_chat/features/conversation/data/datasources/conversation_remote_datasource.dart';
import 'package:flutter_chat/features/conversation/domain/entities/conversation_entity.dart';

import '../../domain/repositories/conversation_repository.dart';

class ConversationsRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDatasource remoteDataSource;

  ConversationsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<ConversationEntity>> fetchConversations() async{
    return await remoteDataSource.fetchConversations();
  }
  
  @override
  Future<ConversationEntity> checkOrCreateConversation( String id) async {
    return await remoteDataSource.checkOrCreateConversation(id);
  }

}