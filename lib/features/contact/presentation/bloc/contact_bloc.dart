// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter_chat/features/contact/domain/usecases/fetch_contact_usecase.dart';

import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContactUseCase fetchContactUseCase;
  final AddContactUseCase addContactUseCase;
  final DeleteContactUseCase deleteContactUseCase;
  ContactBloc(
    this.fetchContactUseCase,
    this.addContactUseCase,
    this.deleteContactUseCase,
  ) : super(ContactInitial()) {
    on<FetchContactEvent>(_onFetchContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    // on<ContactEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }
  Future<void> _onFetchContacts(
      FetchContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await fetchContactUseCase.call();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  void _onAddContact(AddContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      await addContactUseCase.call(
          username: event.username, email: event.email);
      emit(ContactAdded());
      add(FetchContactEvent());
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }

  void _onDeleteContact(
      DeleteContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      await deleteContactUseCase.call(event.id);
      emit(ContactDeleted());
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }
}
