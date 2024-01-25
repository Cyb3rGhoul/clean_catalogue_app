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
}
