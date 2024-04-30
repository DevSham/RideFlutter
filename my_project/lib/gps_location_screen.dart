import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  bool _locationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      setState(() {
        _locationPermissionDenied = true;
      });
    } else if (locationPermission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationPermissionDenied = true;
        });
      } else {
        _getCurrentLocation();
      }
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: _locationPermissionDenied
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Location Permission Denied',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                _checkLocationPermission();
              },
              child: Text('Enable Location Permissions'),
            ),
          ],
        ),
      )
          : _currentPosition != null
          ? GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('currentPosition'),
            position: _currentPosition!,
            infoWindow: InfoWindow(
              title: 'Your Location',
              snippet:
              'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
            ),
          ),
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
