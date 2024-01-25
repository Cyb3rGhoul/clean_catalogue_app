import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  CloudinaryObject.fromCloudName(cloudName: dotenv.env['CLOUD_NAME']!);

  await Firebase.initializeApp(
    name: 'clean-catalogue-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final currUser = FirebaseAuth.instance.currentUser;

  UserModel? user;

  user = UserModel(
    userID: currUser?.uid ?? '',
    username: currUser?.displayName ?? '',
    email: currUser?.email ?? '',
  );

  runApp(
    App(
      initialScreen: currUser != null
          ? ScanScreen(
              currUser: user,
            )
          : const LandingScreen(),
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
