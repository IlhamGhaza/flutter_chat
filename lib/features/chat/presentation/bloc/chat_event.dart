part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadMessageEvent extends ChatEvent {
  final String conversationId;

  LoadMessageEvent({required this.conversationId});
}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String content;

  SendMessageEvent({required this.conversationId, required this.content});
}

class ReceivedMessageEvent extends ChatEvent {
  final Map<String, dynamic> message;
  ReceivedMessageEvent({required this.message});
}

//delete chat
class DeleteChatEvent extends ChatEvent {
  final String conversationId;
  DeleteChatEvent({required this.conversationId});
}
