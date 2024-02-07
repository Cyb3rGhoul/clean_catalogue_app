import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CatalogueImagePicker extends StatefulWidget {
  const CatalogueImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(List<XFile> pickedImages) onPickImage;

  @override
  State<CatalogueImagePicker> createState() {
    return _CatalogueImagePickerState();
  }
}

class _CatalogueImagePickerState extends State<CatalogueImagePicker> {
  List<XFile>? _pickedImages;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxWidth: 150,
    );

    _pickedImages = pickedImage;

    widget.onPickImage(_pickedImages!);
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
            Icons.upload,
            size: 45.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
