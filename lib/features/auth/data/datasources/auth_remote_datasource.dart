import 'dart:convert';
import 'dart:developer';

import '../../../../core/variabeles.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    log('login response: ${response.body}');
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['data']['user']);
    } else {
      log('login error: ${response.body}');
      throw Exception('Failed to login');
    }
  }

  Future<UserModel> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    log('register response: ${response.body}');
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception('Failed to register');
    }
  }
}
