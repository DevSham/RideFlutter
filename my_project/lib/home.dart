import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'picture_upload_screen.dart';
import 'gps_location_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        actions: [
        IconButton(
        icon: const Icon(Icons.person),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute
    <ProfileScreen>(
      builder: (context) => ProfileScreen(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        actions: [
          SignedOutAction((context) {
            Navigator.of(context).pop();
          })
        ],
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(2),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset('assets/ridelink.png'),
            ),
          ),
        ],
      ),
    ),
    );
    },
        )
        ],
          automaticallyImplyLeading: false,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ridelinkTruck.jpeg'),
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
                    builder: (context) => MapScreen(), // Replace MapScreen with the actual screen widget
                  ),
                );
              },
              child: Text('Go to Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the upload picture screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadPictureScreen(), // Replace UploadPictureScreen with the actual screen widget
                  ),
                );
              },
              child: Text('Upload Picture'),
            ),
            const SizedBox(height: 20),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}