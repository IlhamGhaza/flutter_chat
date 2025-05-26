import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/features/chat/domain/usecases/fetch_message_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/socket_service.dart';
import '../../domain/entities/message_entity.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _message = [];
  final _storege = FlutterSecureStorage();

  ChatBloc({required this.fetchMessageUseCase}) : super(ChatInitial()) {
    on<LoadMessageEvent>(_onLoadMessage);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceivedMessageEvent>(_onReceivedMessage);
  }

  Future<void> _onLoadMessage(
      LoadMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessageUseCase(event.conversationId);
      _message.clear();
      _message.addAll(messages);
      emit(ChatLoadedState(messages: _message));

      _socketService.socket.emit('joinConversation', event.conversationId);
      _socketService.socket.on(
          "newMessage",
          (data) => {
                log("step1 -received message: $data"),
                add(ReceivedMessageEvent(message: data))
              });
    } catch (e) {
      emit(ChatErrorState(message: e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    String userId = await _storege.read(key: 'userId') ?? '';
    log('userId: $userId');
    final newMessage = {
      'conversationId': event.conversationId,
      'content': event.content,
      'senderId': userId,
    };
    _socketService.socket.emit('sendMessage', newMessage);
  }

  Future<void> _onReceivedMessage(
      ReceivedMessageEvent event, Emitter<ChatState> emit) async {
    log('step2 -received event called: ${event.message}');

    final message = MessageEntity(
      id: event.message['id'],
      content: event.message['content'],
      senderId: event.message['senderId'],
      conversationId: event.message['conversationId'],
      createdAt: event.message['createdAt'],
    );
    _message.add(message);
    emit(ChatLoadedState(messages: _message));
  }
}
