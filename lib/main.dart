import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/providers/user_provider.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';

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

  User? user = FirebaseAuth.instance.currentUser;

  runApp(
    ProviderScope(
      child: user != null
          ? App(
              userAuthID: user.uid,
              userEmail: user.email!,
              userName: user.displayName!,
            )
          : const MaterialApp(
              home: LandingScreen(),
            ),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  final String userAuthID;
  final String userName;
  final String userEmail;

  const App({
    Key? key,
    required this.userAuthID,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  UserModel? currentUser;
  Widget currScreen = const ScanScreen();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getUser() async {
    try {
      currentUser = await createUser(
        authID: widget.userAuthID,
        email: widget.userEmail,
        name: widget.userName,
      );

      if (currentUser != null) {
        ref.read(userProvider.notifier).changeUserState(
              currentUser!.catalogues,
              userID: currentUser!.userID,
              username: currentUser!.username,
              email: currentUser!.email,
            );
      }
    } catch (error) {
      debugPrint("Error signing in.");
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      setState(() {
        currScreen = const LandingScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _getUser(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo_no_background.png',
                      width: 200,
                      height: 200,
                    ),
                    const CircularProgressIndicator(
                      color: Color(0xFF2F66D0),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return currScreen;
          }
        },
      ),
    );
  }
}
