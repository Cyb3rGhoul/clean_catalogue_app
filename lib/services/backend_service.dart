import 'dart:convert';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<UserModel?> createUser(
    {required String name,
    required String email,
    required String authID}) async {
  UserModel? currUser;

  try {
    final url = Uri.parse('http://localhost:3000/user/create');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'name': name,
      'email': email,
      'authID': authID,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      debugPrint('User created successfully!');
    } else if (response.statusCode == 400) {
      debugPrint('User found successfully!');
    }

    final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final userData = parsedResponse['data'] as Map<String, dynamic>;

    currUser = UserModel(
      userID: userData['authID'],
      username: userData['name'],
      email: userData['email'],
    );

    return currUser;
  } catch (error) {
    debugPrint(error.toString());
  }

  return null;
}
