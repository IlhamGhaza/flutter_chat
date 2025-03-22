
import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<List<ContactEntity>> fetchContacts();
  Future<ContactEntity> fetchContactById(String id);
  Future<void> addContact({String username, String email});
  // Future<List<ContactEntity>> searchContactByEmailAndUsername(String query);  
  Future<void> deleteContact(String id);
}