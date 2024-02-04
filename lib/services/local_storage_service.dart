import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';

Future<void> saveNewUser({required UserModel userModel}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userMap = userModel.toMap();
    final encodedUser = jsonEncode(userMap);
    await prefs.setString('user', encodedUser);
  } catch (error) {
    debugPrint(error.toString());
    throw Error();
  }
}

Future<UserModel?> getLoggedInUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final encodedUser = prefs.getString('user');

    if (encodedUser != null) {
      final userMap = jsonDecode(encodedUser) as Map<String, dynamic>;
      final userModel = UserModel.fromMap(userMap);
      return userModel;
    }
  } catch (error) {
    debugPrint(error.toString());
    throw Error();
  }

  return null;
}

Future<void> saveCatalogueToDB({required Catalogue catalogue}) async {
  try {
    final loggedInUser = await getLoggedInUser();

    if (loggedInUser != null) {
      if (loggedInUser.catalogues == null) {
        loggedInUser.catalogues = [catalogue];
      } else {
        loggedInUser.catalogues?.add(catalogue);
      }
      await saveNewUser(userModel: loggedInUser);
    }
  } catch (error) {
    debugPrint(error.toString());
  }
}
