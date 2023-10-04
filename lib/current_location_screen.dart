import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:my_app/database_helper.dart';
import 'package:my_app/location_data_screen.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  Set<Marker> markers = {};

  late Timer _timer;
  late DatabaseHelper _databaseHelper;
  List<Map<String, dynamic>> locationDataList = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
   
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 15), (timer) async {
      Position position = await _determinePosition();
      _saveLocationData(position);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  Future<void> _saveLocationData(Position position) async {
    Map<String, dynamic> locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _databaseHelper.insertLocation(locationData); 
    setState(() {
      locationDataList.add(locationData);
    });
  }

  void _displayLocationData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationDataScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 38,
        backgroundColor: Color.fromARGB(255, 9, 1, 65),
        elevation: 0,
        title: const Text(
          " Location",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await _determinePosition();
          _saveLocationData(position);

          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)),
          );

          markers.clear();
          markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));

          setState(() {});
        },
        label: const Text(
          "Your Location",
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.location_history,
          color: Colors.red,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _displayLocationData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 7, 1, 63),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text("Display History"),
            ),
          ],
        ),  
      ),
    );
  }
}
