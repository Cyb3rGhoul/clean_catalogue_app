import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/screens/scan_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/providers/user_provider.dart';
import 'package:clean_catalogue_app/services/local_storage_service.dart';

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

  User? isUserAuthenticated = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser = await getLoggedInUser();

  runApp(
    ProviderScope(
      child: App(
        isUserAuthenticated: isUserAuthenticated,
        loggedInUser: loggedInUser,
      ),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  final UserModel? loggedInUser;
  final User? isUserAuthenticated;

  const App({
    Key? key,
    required this.loggedInUser,
    required this.isUserAuthenticated,
  }) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        if (widget.isUserAuthenticated != null && widget.loggedInUser != null) {
          ref.read(userProvider.notifier).createUserState(
                widget.loggedInUser!.catalogues,
                userID: widget.loggedInUser!.userID,
                username: widget.loggedInUser!.username,
                email: widget.loggedInUser!.email,
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currScreen = const LandingScreen();

    if (widget.isUserAuthenticated != null && widget.loggedInUser != null) {
      currScreen = const ScanScreen();
    }

    return MaterialApp(
      home: currScreen,
    );
  }
}
