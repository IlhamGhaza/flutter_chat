import 'package:flutter_chat/features/contact/domain/repositories/contact_reposotory.dart';

import '../entities/contact_entity.dart';

class FetchContactUseCase {
  final ContactRepository contactRepository;

  FetchContactUseCase({required this.contactRepository});

  Future<List<ContactEntity>> call()async{
    return await contactRepository.fetchContacts();

  }
}