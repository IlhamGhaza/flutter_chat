import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

class FetchMessageUseCase {
  final MessageRepository messageRepository;

  FetchMessageUseCase({required this.messageRepository});

  Future<List<MessageEntity>> call(String conversationId) async {
    return await messageRepository.fetchMessages(conversationId);
  }
}
