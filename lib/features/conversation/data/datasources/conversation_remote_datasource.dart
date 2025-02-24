import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:http/http.dart' as http;

import '../../../../core/variabeles.dart';
import '../models/conversation_model.dart';

class ConversationRemoteDatasource {
  final _authLocalDatasource = AuthLocalDatasource();
  Future<List<ConversationModel>> fetchConversations() async {
    await _authLocalDatasource.getToken();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/conversations/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _authLocalDatasource.getToken()}',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }
}
