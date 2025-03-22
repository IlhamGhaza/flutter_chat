import 'package:flutter_chat/features/contact/domain/entities/contact_entity.dart';
import 'package:flutter_chat/features/contact/domain/repositories/contact_reposotory.dart';

import '../datasources/contact_remote_datasource.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDatasource contactRemoteDatasource;

  ContactRepositoryImpl({required this.contactRemoteDatasource});

  @override
  Future<void> addContact({String? username, String? email}) async {
    // TODO: implement addContact
    return await contactRemoteDatasource.addContact(
        username: username, email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    // TODO: implement fetchContacts
    return await contactRemoteDatasource.fetchContacts();
  }

  @override
  Future<ContactEntity> fetchContactById(String id) async {
    // TODO: implement fetchContactById
    return await contactRemoteDatasource.getContactById(id);
  }

  @override
  Future<void> deleteContact(String id) async {
    // TODO: implement deleteContact
    return await contactRemoteDatasource.deleteContact(id);
  }
}
