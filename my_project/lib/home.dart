import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:my_project/display_image_screen.dart';
import 'picture_upload_screen.dart';
import 'gps_location_screen.dart';

class HomeScreen extends StatelessWidget {
  final dynamic user;
  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    late Future<String?> _photoUrlFuture;
    // Fetch the user's photo URL from Firebase Storage using the user's UID
    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('${user}');
    _photoUrlFuture = storageRef.getDownloadURL();
    return Scaffold(
      appBar: AppBar(
        actions: [
          FutureBuilder<String?>(
            future: _photoUrlFuture,
            builder: (context, snapshot) {
              final userPhotoUrl = snapshot.data;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<ProfileScreen>(
                        builder: (context) => ProfileScreen(
                              appBar: AppBar(
                                title: const Text('User Profile'),
                              ),
                              actions: [
                                SignedOutAction((context) {
                                  Navigator.of(context).pop();
                                })
                              ],
                              avatar: FutureBuilder<String?>(
                                future: _photoUrlFuture,
                                builder: (context, snapshot) {
                                  final userPhotoUrl = snapshot.data;
                                  return CircleAvatar(
                                    backgroundImage: userPhotoUrl != null
                                        ? NetworkImage(userPhotoUrl)
                                        : const NetworkImage(
                                            'https://avatar.iran.liara.run/public/boy?username=Ash'),
                                  );
                                },
                              ),
                            )),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: userPhotoUrl != null
                      ? NetworkImage(userPhotoUrl!)
                      : const NetworkImage(
                          'https://avatar.iran.liara.run/public/boy?username=Ash'),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              child: Image.asset(
                'assets/ridelinkTruck.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the map screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MapScreen(), // Replace MapScreen with the actual screen widget
                  ),
                );
              },
              child: const Text('Go to Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the upload picture screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadPictureScreen(user),
                  ),
                );
              },
              child: const Text('Upload Picture'),
            ),
            const SizedBox(height: 20),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}

class CustomImageAvatar extends StatelessWidget {
  const CustomImageAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/your-custom-image.png'),
        radius: 20,
      ),
    );
  }
}
