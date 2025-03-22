import '../repositories/contact_reposotory.dart';

class DeleteContactUseCase {
  final ContactRepository contactRepository;

  DeleteContactUseCase({required this.contactRepository});

  Future<void> call(String id) async {
    await contactRepository.deleteContact(id);
  }
}