import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadPictureScreen extends StatefulWidget {
  const UploadPictureScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadPictureScreenState createState() => _UploadPictureScreenState();
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    firebase_storage.UploadTask uploadTask =
        ref.putFile(File(_imageFile!.path));
    firebase_storage.TaskSnapshot snapshot =
        await uploadTask.whenComplete(() => null);
    String imageUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    File(_imageFile!.path),
                    height: 200,
                  )
                : const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImageToFirebase,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            _imageUrl != null
                ? Text(
                    'Image URL: $_imageUrl',
                    style: const TextStyle(fontSize: 16),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
