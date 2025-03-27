import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    required super.id,
    required super.username,
    required super.email,
    required super.photoProfile,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['contact_id'] as int,
      username: json['username'],
      email: json['email'],
      photoProfile: json['photo_profile'],
    );
  }
}
