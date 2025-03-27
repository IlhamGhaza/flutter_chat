import '../entities/conversation_entity.dart';
import '../repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository repository;

  CheckOrCreateConversationUseCase({required this.repository});


 Future<ConversationEntity> call(String id) async {
    return await repository.checkOrCreateConversation(id);
  }
}
