import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserModel?> signInWithGoogle() async {
  UserModel? currUser;

  try {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final response =
        await FirebaseAuth.instance.signInWithCredential(credential);

    currUser = await createUser(
      authID: response.user?.uid ?? '',
      email: response.user?.email ?? '',
      name: response.user?.displayName ?? '',
    );

    return currUser;
  } catch (error) {
    debugPrint(error.toString());
  }

  return null;
}
