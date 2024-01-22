import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CloudinaryObject.fromCloudName(cloudName: "df3lxtjcl");

  await Firebase.initializeApp(
    name: 'clean-catalogue-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = FirebaseAuth.instance.currentUser;

  runApp(
    App(
      initialScreen: user != null ? const ScanScreen() : const LandingScreen(),
    ),
  );
}

class App extends StatelessWidget {
  final Widget initialScreen;

  const App({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: initialScreen,
    );
  }
}
