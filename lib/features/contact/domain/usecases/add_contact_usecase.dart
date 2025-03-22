import '../repositories/contact_reposotory.dart';

class AddContactUseCase {
  final ContactRepository contactRepository;

  AddContactUseCase({required this.contactRepository});

  Future<void> call({String? username, String? email}) async {
    await contactRepository.addContact(username: username.toString(), email: email.toString());
  }
}