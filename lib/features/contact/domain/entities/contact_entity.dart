class ContactEntity {
  final int id;
  final String username;
  final String email;
  final dynamic photoProfile;

  ContactEntity(
      {required this.id,
      required this.username,
      required this.email,
      required this.photoProfile});
}
