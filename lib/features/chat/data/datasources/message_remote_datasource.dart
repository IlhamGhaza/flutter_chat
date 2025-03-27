import 'dart:convert';
import 'dart:developer';

import 'package:flutter_chat/features/chat/data/models/message_model.dart';
import 'package:flutter_chat/features/chat/domain/entities/message_entity.dart';
import 'package:http/http.dart' as http;

import '../../../../core/variabeles.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
class MessageRemoteDatasource {
  final _authLocalDatasource = AuthLocalDatasource();
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    final token = await _authLocalDatasource.getToken();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/messages/$conversationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('get all message response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}