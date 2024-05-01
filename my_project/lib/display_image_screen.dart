import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageDisplayScreen extends StatefulWidget {
  const ImageDisplayScreen({super.key, required String imageUrl});

  @override
  // ignore: library_private_types_in_public_api
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  late String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchImageFromFirebase();
  }

  Future<void> _fetchImageFromFirebase() async {
    // Replace 'your-image-path' with the actual path to your image in Firebase Storage
    String imagePath = 'gs://myproject-93415.appspot.com';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image from Firebase'),
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: _imageUrl != null
            ? Image.network(
                _imageUrl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
              )
            : const CircularProgressIndicator(), // Display a progress indicator while loading the image
      ),
    );
  }
}
