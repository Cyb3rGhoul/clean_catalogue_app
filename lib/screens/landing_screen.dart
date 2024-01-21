import 'auth_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() {
    return _LandingScreenState();
  }
}

class _LandingScreenState extends State<LandingScreen> {
  void pushAuthScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Landing Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              pushAuthScreen(context);
            },
            icon: const Icon(
              Icons.login,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Landing Page Content...",
        ),
      ),
    );
  }
}
