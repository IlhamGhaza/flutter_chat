import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required int id,
    required super.username,
    required super.email,
    required super.token,
  }) : super(id: id.toString());

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }
}
