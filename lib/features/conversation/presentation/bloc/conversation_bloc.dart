import 'package:bloc/bloc.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/fetch_conversation_use_case.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationUseCase fetchConversationUseCase;

  ConversationBloc({required this.fetchConversationUseCase})
      : super(ConversationInitial()) {
    on<FetchConversations>(_onFetchConversations);
  }

  Future<void> _onFetchConversations(
      FetchConversations event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    try {
      final conversations = await fetchConversationUseCase();
      emit(ConversationLoaded(conversations: conversations));
    } catch (e) {
      emit(ConversationError(message: 'Failed to load conversations'));
    }
  }
}
