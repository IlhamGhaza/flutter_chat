part of 'contact_bloc.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactEntity> contacts;
  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;
  ContactError({required this.message});
}

class ContactAdded extends ContactState {}

class ContactDeleted extends ContactState {}

