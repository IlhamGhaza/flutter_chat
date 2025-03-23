import '../entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();

  Future<String> checkOrCreateConversation(String id);
}
