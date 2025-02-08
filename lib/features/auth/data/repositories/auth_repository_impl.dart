import 'package:flutter_chat/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    // TODO: implement login
    return await authRemoteDatasource.login(email, password);
    // throw UnimplementedError();
  }

  @override
  Future<UserEntity> register(
      String username, String email, String password) async {
    // TODO: implement register
    return await authRemoteDatasource.register(username, email, password);
    // throw UnimplementedError();
  }
}
