import 'package:clean_catalogue_app/models/catalogue_model.dart';

class UserModel {
  final String userID;
  final String username;
  final String email;
  List<Catalogue>? catalogues;

  UserModel({
    required this.userID,
    required this.username,
    required this.email,
    this.catalogues,
  });

  UserModel copyWith({
    String? userID,
    String? username,
    String? email,
    List<Catalogue>? catalogues,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      email: email ?? this.email,
      catalogues: catalogues ?? this.catalogues,
    );
  }
}
