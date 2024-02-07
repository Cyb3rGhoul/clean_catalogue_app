import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CatalogueImageClicker extends StatefulWidget {
  const CatalogueImageClicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(List<XFile> pickedImages) onPickImage;

  @override
  State<CatalogueImageClicker> createState() {
    return _CatalogueImageClickerState();
  }
}

class _CatalogueImageClickerState extends State<CatalogueImageClicker> {
  final List<XFile> _pickedImages = [];

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      _pickedImages.add(pickedImage);
      widget.onPickImage(_pickedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: PhysicalModel(
        color: Colors.white,
        elevation: 4.0,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
        child: const SizedBox(
          width: 100.0,
          height: 100.0,
          child: Icon(
            Icons.camera_alt,
            size: 45.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
