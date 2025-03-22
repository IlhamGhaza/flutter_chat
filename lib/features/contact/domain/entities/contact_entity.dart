import 'dart:ffi';

class ContactEntity {
  final Int id;
  final String username;
  final String email;
  final dynamic photoProfile;

  ContactEntity(
      {required this.id,
      required this.username,
      required this.email,
      required this.photoProfile});
}
