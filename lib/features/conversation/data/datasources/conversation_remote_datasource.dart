import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../core/variabeles.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/conversation_model.dart';

class ConversationRemoteDatasource {
  final _authLocalDatasource = AuthLocalDatasource();
  Future<List<ConversationModel>> fetchConversations() async {
    final token = await _authLocalDatasource.getToken();
    log('token:  $token');
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/conversations/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('get all conversations response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonData = jsonResponse['data'];
      return jsonData.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<ConversationModel> checkOrCreateConversation(String id) async {
    final token = await _authLocalDatasource.getToken();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/conversations/check-or-create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'participantId': id,
      }),
    );
    log('check or create conversation response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ConversationModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to check or create conversation');
    }
  }
}
