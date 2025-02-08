//save token user in local storage key: 'token', value: 'user.token'

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }
}