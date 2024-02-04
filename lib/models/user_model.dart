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

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'username': username,
      'email': email,
      'catalogues': catalogues?.map((catalogue) => catalogue.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      catalogues: (map['catalogues'] is List)
          ? (map['catalogues'] as List)
              .map((catalogueMap) => Catalogue.fromMap(catalogueMap))
              .toList()
          : null,
    );
  }
}
