import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:clean_catalogue_app/signup_image.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/components/google_signin_button.dart';
import 'package:clean_catalogue_app/services/google_auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isAuthenticating = false;

  void _setIsAuthenticating() {
    setState(() {
      _isAuthenticating = !_isAuthenticating;
    });
  }

  void _showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToScanScreen(UserModel user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ScanScreen(currUser: user),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    UserModel? currUser;

    try {
      _setIsAuthenticating();
      currUser = await signInWithGoogle();
    } catch (error) {
      _showSnackBar(message: error.toString());
    } finally {
      _setIsAuthenticating();
      if (currUser != null) _navigateToScanScreen(currUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.string(
                svgString,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[350],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email ID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[350],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[350],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              if (!_isAuthenticating)
                SignInButton(
                  ontap: _signInWithGoogle,
                ),
              if (_isAuthenticating) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
