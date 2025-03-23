import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../core/variabeles.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
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
    log('get all conversations response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<String> checkOrCreateConversation(String id) async {
    await _authLocalDatasource.getToken();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/conversations/c/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _authLocalDatasource.getToken()}',
      },
      body: jsonEncode({
        'participantId': id,
      }),
    );
    log('check or create conversation response: ${response.body}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to check or create conversation');
    }
  }
}
