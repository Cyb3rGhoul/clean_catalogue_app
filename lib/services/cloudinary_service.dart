import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:clean_catalogue_app/models/catalogue_model.dart';

Future<void> uploadToCloudinary(
    XFile image, List<ImageObject> uploadedUrls) async {
  await dotenv.load(fileName: ".env");

  try {
    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.cloudinary.com/v1_1/${dotenv.env['CLOUD_NAME']}/upload'))
      ..fields['upload_preset'] = dotenv.env['UPLOAD_PRESET']!
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      ImageObject imageObject = ImageObject(
          name: jsonMap['original_filename'], imageUrl: jsonMap['url']);

      uploadedUrls.add(imageObject);
      debugPrint("Added URL: ${uploadedUrls.last.imageUrl}");
    }
  } catch (error) {
    debugPrint(error.toString());
    debugPrint("error occured.");
    return;
  }
}
