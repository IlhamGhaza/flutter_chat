import '../entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();

  Future<ConversationEntity> checkOrCreateConversation(String id);
}
