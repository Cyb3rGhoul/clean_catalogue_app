import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() {
    return _ScanScreenState();
  }
}

class _ScanScreenState extends State<ScanScreen> {
  void navigateToLandingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    navigateToLandingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Scan Screen Components",
        ),
      ),
    );
  }
}
