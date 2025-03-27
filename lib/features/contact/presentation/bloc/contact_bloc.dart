// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_chat/features/contact/domain/usecases/fetch_contact_usecase.dart';

import '../../../conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContactUseCase fetchContactUseCase;
  final AddContactUseCase addContactUseCase;
  final DeleteContactUseCase deleteContactUseCase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;

  ContactBloc(
      {required this.fetchContactUseCase,
      required this.addContactUseCase,
      required this.deleteContactUseCase,
      required this.checkOrCreateConversationUseCase})
      : super(ContactInitial()) {
    on<FetchContactEvent>(_onFetchContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<CheckOrCreateConversationEvent>(_onCheckOrCreateConversation);
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
      emit(ContactError(message: 'Failed to load contacts'));
      log('failed load contacts: ${e.toString()}\n');
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

  void _onCheckOrCreateConversation(
      CheckOrCreateConversationEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final conversationId = await checkOrCreateConversationUseCase
          .call(event.contactId.id.toString());
      if (conversationId != null) {
        emit(ConversationCreated(
            conversationId.toString(), event.contactId.username));
      } else {
        emit(ContactError(message: 'Failed to create conversation'));
      }
    } catch (e) {
      emit(ContactError(message: e.toString()));
    }
  }
}
