import 'dart:convert';
import 'dart:developer';
import 'package:flutter_chat/features/contact/data/models/contact_model.dart';

import '../../../../core/variabeles.dart';
import 'package:http/http.dart' as http;

import '../../../auth/data/datasources/auth_local_datasource.dart';

class ContactRemoteDatasource {
  final _authLocalDatasource = AuthLocalDatasource();

  Future<List<ContactModel>> fetchContacts() async {
    final token = await _authLocalDatasource.getToken();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/contacts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('get all contact response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  //get by id
  Future<ContactModel> getContactById(String id) async {
    final token = await _authLocalDatasource.getToken();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/contacts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('get by id contact response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return ContactModel.fromJson(data[0]);
      // return ContactModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load contact');
    }
  }

  //add contact by username or email
  Future<void> addContact({String? username, String? email}) async {
    final token = await _authLocalDatasource.getToken();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/contacts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
      }),
    );
    log('add contact response: ${response.body}');
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to add contact');
    }
  }

  //delete contact by id
  Future<void> deleteContact(String id) async {
   final token =  await _authLocalDatasource.getToken();
    final response = await http.delete(
      Uri.parse('${Variables.baseUrl}/contacts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('delete contact response: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Failed to delete contact');
    }
  }
}
