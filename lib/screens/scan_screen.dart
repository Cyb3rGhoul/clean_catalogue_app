import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_catalogue_app/models/user_model.dart';
import 'package:clean_catalogue_app/components/main_drawer.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';
import 'package:clean_catalogue_app/screens/history_screen.dart';
import 'package:clean_catalogue_app/screens/landing_screen.dart';
import 'package:clean_catalogue_app/services/backend_service.dart';
import 'package:clean_catalogue_app/services/cloudinary_service.dart';
import 'package:clean_catalogue_app/components/user_image_picker.dart';
import 'package:clean_catalogue_app/models/catalogue_scores_model.dart';
import 'package:clean_catalogue_app/screens/catalogue_detail_screen.dart';

var uuid = const Uuid();

class ScanScreen extends StatefulWidget {
  final UserModel currUser;

  const ScanScreen({super.key, required this.currUser});

  @override
  State<ScanScreen> createState() {
    return _ScanScreenState();
  }
}

class _ScanScreenState extends State<ScanScreen> {
  final _form = GlobalKey<FormState>();

  var _isUploading = false;

  String _enteredName = '';
  String? _enteredDescription;

  String _getRandomUID() {
    return uuid.v4();
  }

  void _setIsUploading() {
    setState(() {
      _isUploading = !_isUploading;
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
    _setIsUploading();

    if (_form.currentState == null) {
      _setIsUploading();
      debugPrint("Form error occured");
      return;
    }

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      _setIsUploading();
      return;
    }

    _form.currentState!.save();

    final List<ImageObject> uploadedUrls = [];

    if (images.isEmpty) {
      _setIsUploading();
      return;
    }

    CatalogueScores? scores;

    try {
      for (final XFile image in images) {
        await uploadToCloudinary(image, uploadedUrls);
      }

      scores = await scanCatalogue(
          images: uploadedUrls,
          catalogueName: _enteredName,
          catalogueDescription: _enteredDescription,
          currUser: widget.currUser);
    } catch (error) {
      _setIsUploading();
      debugPrint(error.toString());
      _showSnackBar(message: "An error occured.");
      return;
    }

    final Catalogue catalogue = Catalogue(
      catalogueID: _getRandomUID(),
      name: _enteredName,
      images: uploadedUrls,
      date: DateTime.now(),
      description: _enteredDescription,
      result: scores!,
    );

    if (widget.currUser.catalogues == null) {
      widget.currUser.catalogues = [catalogue];
    } else {
      widget.currUser.catalogues?.add(catalogue);
    }

    _form.currentState!.reset();
    _showSnackBar(message: "Catalogue Uploaded.");
    _setIsUploading();
    _navigateToCatalogueDetailScreen(catalogue: catalogue);
  }

  void _navigateToCatalogueDetailScreen({required Catalogue catalogue}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatalogueDetailScreen(
            catalogue: catalogue, currUser: widget.currUser),
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
          builder: (ctx) => HistoryScreen(
            currUser: widget.currUser,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        currUser: widget.currUser,
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
                  !_isUploading
                      ? UserImagePicker(onPickImage: _uploadImages)
                      : CircularProgressIndicator()
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.fromLTRB(28, 20, 28, 40),
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
        ],
      ),
    );
  }
}
