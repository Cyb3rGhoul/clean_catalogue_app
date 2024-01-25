import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/components/main_drawer.dart';

class HistoryScreen extends StatefulWidget {
  final UserModel currUser;

  const HistoryScreen({super.key, required this.currUser});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'scan') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ScanScreen(currUser: widget.currUser),
        ),
      );
    }
  }

  void _navigateToLandingScreen() {
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
    _navigateToLandingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue History'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(
        currUser: widget.currUser,
        onSelectScreen: _setScreen,
      ),
      body: const Center(
        child: Text("History..."),
      ),
    );
  }
}
