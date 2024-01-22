import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/services/cloudinary_service.dart';
import 'package:clean_catalogue_app/components/user_image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() {
    return _ScanScreenState();
  }
}

class _ScanScreenState extends State<ScanScreen> {
  List<String> uploadedUrls = [];

  Future<void> uploadImages(List<XFile> images) async {
    for (final XFile image in images) {
      await uploadToCloudinary(image, uploadedUrls);
    }
    debugPrint(uploadedUrls.toString());
  }

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
      body: Center(
        child: UserImagePicker(
          onPickImage: uploadImages,
        ),
      ),
    );
  }
}
