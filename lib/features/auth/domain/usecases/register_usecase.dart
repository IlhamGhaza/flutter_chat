import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});
  Future<void> call(String username, String email, String password) async {
    await repository.register(username, email, password);
  }
}