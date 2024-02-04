import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/components/main_drawer.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/screens/history_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/providers/user_provider.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';
import 'package:clean_catalogue_app/services/cloudinary_service.dart';
import 'package:clean_catalogue_app/components/user_image_picker.dart';
import 'package:clean_catalogue_app/models/catalogue_scores_model.dart';
import 'package:clean_catalogue_app/services/local_storage_service.dart';
import 'package:clean_catalogue_app/screens/catalogue_detail_screen.dart';

var uuid = const Uuid();

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() {
    return _ScanScreenState();
  }
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _form = GlobalKey<FormState>();

  var _isUploading = false;
  var _isScanning = false;

  String _enteredName = '';
  String? _enteredDescription;

  List<ImageObject> uploadedUrls = [];

  String _getRandomUID() {
    return uuid.v4();
  }

  void _setIsUploading() {
    setState(() {
      _isUploading = !_isUploading;
    });
  }

  void _setIsScanning() {
    setState(() {
      _isScanning = !_isScanning;
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

  Future<void> _uploadImages(List<XFile> images) async {
    if (images.isEmpty) {
      _showSnackBar(message: "No images were selected.");
      return;
    }

    try {
      _setIsUploading();
      final uploads =
          images.map((image) => uploadToCloudinary(image, uploadedUrls));
      await Future.wait(uploads);
      _showSnackBar(message: "Uploaded images successfully.");
      _setIsUploading();
    } catch (error) {
      uploadedUrls.clear();
      _setIsUploading();
      debugPrint(error.toString());
      _showSnackBar(message: "An error occured uploading images, try again.");
      return;
    }
  }

  Future<void> _scanCatalogue(UserModel currUser) async {
    CatalogueScores? scores;
    List<ImageObject> urlList = [...uploadedUrls];

    if (_form.currentState == null) {
      debugPrint("Form error occured");
      return;
    }

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    if (urlList.isEmpty) {
      _showSnackBar(message: "Images not found.");
      return;
    }

    try {
      _setIsScanning();
      scores = await scanCatalogue(
        images: urlList,
        catalogueName: _enteredName,
        catalogueDescription: _enteredDescription,
        currUser: currUser,
      );

      final Catalogue catalogue = Catalogue(
        catalogueID: _getRandomUID(),
        name: _enteredName,
        images: urlList,
        date: DateTime.now(),
        description: _enteredDescription,
        result: scores!,
      );

      ref.watch(userProvider.notifier).addStateCatalogue(catalogue);
      await saveCatalogueToDB(catalogue: catalogue);

      _form.currentState!.reset();
      _showSnackBar(message: "Catalogue scanned successfully.");
      _setIsScanning();
      _navigateToCatalogueDetailScreen(catalogue: catalogue);
      uploadedUrls.clear();
    } catch (error) {
      _setIsScanning();
      debugPrint(error.toString());
      _showSnackBar(
        message: "An error occured scanning catalogue, please try again later.",
      );
      uploadedUrls.clear();
      return;
    }
  }

  void _navigateToCatalogueDetailScreen({required Catalogue catalogue}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatalogueDetailScreen(
          catalogue: catalogue,
        ),
      ),
    );
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

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'history') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const HistoryScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currUser = ref.watch(userProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Scan Catalogue'),
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
            currUser: currUser,
            onSelectScreen: _setScreen,
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserImagePicker(
                        onPickImage: _uploadImages,
                        message: _isUploading
                            ? 'Uploading...'
                            : uploadedUrls.isNotEmpty
                                ? 'Add More'
                                : 'Upload Catalogue',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(28, 20, 28, 20),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 50, 14, 30),
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Name of the Catalogue',
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
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter at least 4 characters.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredName = value!;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Description',
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
                                height: 8,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 7,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    expands: true,
                                    maxLines: null,
                                    onSaved: (value) {
                                      _enteredDescription = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  !(_isUploading || _isScanning)
                      ? _scanCatalogue(currUser)
                      : null;
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(42, 0, 42, 0),
                  elevation: 4,
                  backgroundColor: const Color(0xFF2F66D0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isScanning ? "Scanning..." : "Scan",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
