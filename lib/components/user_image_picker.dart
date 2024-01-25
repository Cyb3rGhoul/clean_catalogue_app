import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(List<XFile> pickedImages) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  List<XFile>? _pickedImages;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImages = pickedImage;
    });

    widget.onPickImage(_pickedImages!);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Upload catalogue',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
