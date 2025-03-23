import '../repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository repository;

  CheckOrCreateConversationUseCase({required this.repository});


 Future<String> call(String id) async {
    return await repository.checkOrCreateConversation(id);
  }
}
