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
import 'package:clean_catalogue_app/models/catalogue_scores_model.dart';
import 'package:clean_catalogue_app/services/local_storage_service.dart';
import 'package:clean_catalogue_app/components/edit_image_list_item.dart';
import 'package:clean_catalogue_app/screens/catalogue_detail_screen.dart';
import 'package:clean_catalogue_app/components/catalogue_image_picker.dart';
import 'package:clean_catalogue_app/components/catalogue_image_clicker.dart';

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

  void _showSnackBar(
      {String? actionMessage,
      Function? actionFunction,
      required String message}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: actionMessage != null && actionFunction != null
            ? SnackBarAction(
                label: actionMessage,
                onPressed: () => actionFunction(),
              )
            : null,
      ),
    );
  }

  Future<void> _uploadImages(List<XFile> images) async {
    Navigator.of(context).pop();
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

  void _showEditModal() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setS) {
          return SafeArea(
            bottom: true,
            child: SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "Edit Images",
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: uploadedUrls.isNotEmpty
                          ? ListView.builder(
                              itemCount: uploadedUrls.length,
                              itemBuilder: (context, index) {
                                return EditImageListItem(
                                    imageIndex: index + 1,
                                    imageName: uploadedUrls[index].name,
                                    onDeleteImage: () {
                                      setState(() {
                                        uploadedUrls.removeAt(index);
                                      });
                                    });
                              },
                            )
                          : const Center(
                              child: Text(
                                "No catalogues yet, start scanning.",
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showImageInputModal() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
          return SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(55, 20, 55, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CatalogueImagePicker(
                          onPickImage: _uploadImages,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Pick Image",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CatalogueImageClicker(onPickImage: _uploadImages),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Take Photo",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
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
    if (identifier == 'history') {
      Navigator.of(context).pushReplacement(
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
          resizeToAvoidBottomInset: false,
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
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (uploadedUrls.isNotEmpty || _isUploading)
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _isUploading
                                  ? 'Uploading...'
                                  : '${uploadedUrls.length} image${uploadedUrls.length > 1 ? 's' : ''} uploaded',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _showImageInputModal,
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 30,
                              ),
                            ),
                            if (uploadedUrls.isNotEmpty)
                              ElevatedButton(
                                onPressed: _showEditModal,
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                ),
                              ),
                          ],
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
      ),
    );
  }
}
