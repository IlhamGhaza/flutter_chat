part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<MessageEntity> messages;
  ChatLoadedState({required this.messages});
}

class ChatErrorState extends ChatState {
  final String message;
  ChatErrorState({required this.message});
}
