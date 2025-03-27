part of 'contact_bloc.dart';

abstract class ContactEvent {}

class FetchContactEvent extends ContactEvent {}

class AddContactEvent extends ContactEvent {
  final String? username;
  final String? email;
  AddContactEvent({this.username, this.email});
}

class DeleteContactEvent extends ContactEvent {
  final String id;

  DeleteContactEvent({required this.id});
}

class CheckOrCreateConversationEvent extends ContactEvent {
  final ContactEntity contactId;
  final String contactName;
CheckOrCreateConversationEvent( { required this.contactId, required this.contactName});
}

class ConversationCreated extends ContactState {
  final String conversationId;
  final String contactName;

  ConversationCreated(this.conversationId, this.contactName);
}
