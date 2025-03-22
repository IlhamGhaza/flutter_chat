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
