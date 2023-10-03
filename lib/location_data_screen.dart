import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/database_helper.dart';

void main() {
  runApp(MaterialApp(
    home: LocationDataScreen(),
  ));
}

class LocationDataScreen extends StatefulWidget {
  @override
  _LocationDataScreenState createState() => _LocationDataScreenState();
}

class _LocationDataScreenState extends State<LocationDataScreen> {
  late DatabaseHelper _databaseHelper;
  List<Map<String, dynamic>> locationDataList = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    final data = await _databaseHelper.getLocationData();
    setState(() {
      locationDataList = data;
    });
  }

  void _viewLocationOnMap(double latitude, double longitude) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationMapScreen(
          latitude: latitude,
          longitude: longitude,
          locationDataList: locationDataList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 38,
        backgroundColor: Color.fromARGB(255, 8, 2, 70),
        title: Row(
          children: [
            SizedBox(width: 30,),
            Text("Location History"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: locationDataList.length,
        itemBuilder: (context, index) {
          final locationData = locationDataList[index];
          final latitude = locationData['latitude'];
          final longitude = locationData['longitude'];
          final timestamp = locationData['timestamp'];

          return Dismissible(
            key: Key(timestamp), 
            onDismissed: (direction) {
            
              setState(() {
                locationDataList.removeAt(index);
              });
              _databaseHelper.deleteLocation(timestamp);
            },
            background: Container(
              color: Colors.red, 
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text("Latitude: $latitude, Longitude: $longitude"),
                subtitle: Text("Timestamp: $timestamp"),
                onTap: () {
                  _viewLocationOnMap(latitude, longitude);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class LocationMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> locationDataList;

  LocationMapScreen({
    required this.latitude,
    required this.longitude,
    required this.locationDataList,
  });

  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  late GoogleMapController _mapController;
  int playbackIndex = 0;
  bool isPlaying = false;
  bool showPolylines = true;
  List<LatLng> locationHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeLocationHistory();
  }

  void _initializeLocationHistory() {
    for (final locationData in widget.locationDataList) {
      final latitude = locationData['latitude'];
      final longitude = locationData['longitude'];
      locationHistory.add(LatLng(latitude, longitude));
    }
  }

  void _playbackLocationHistory() async {
    setState(() {
      isPlaying = true;
    });

    for (var i = playbackIndex; i < locationHistory.length; i++) {
      final location = locationHistory[i];
      await Future.delayed(Duration(seconds: 1)); 
      if (mounted) {
        _mapController.animateCamera(CameraUpdate.newLatLng(location));
        setState(() {
          playbackIndex = i;
        });
      }
    }

    setState(() {
      isPlaying = false;
    });
  }

  void _togglePolylines() {
    setState(() {
      showPolylines = !showPolylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialLocation = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 6, 1, 44),
        title: Row(
          children: [
            SizedBox(
              width: 28,
            ),
            Text(
              "Location on Map",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: initialLocation,
            markers: {
              Marker(
                markerId: MarkerId('locationMarker'),
                position: LatLng(widget.latitude, widget.longitude),
                infoWindow: InfoWindow(
                  title: 'Location',
                  snippet:
                      'Latitude: ${widget.latitude}, Longitude: ${widget.longitude}',
                ),
              ),
            },
            polylines: {
              if (showPolylines) 
                Polyline(
                  polylineId: PolylineId('locationHistory'),
                  points: locationHistory,
                  color: Colors.blue,
                  width: 5,
                ),
            },
          ),
          Positioned(
            left: 16, 
            right: 16,
            bottom: 16, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(
                      showPolylines ? Icons.pause : Icons.play_arrow,
                      color: Color.fromARGB(255, 33, 3, 116),
                      size: 30,
                    ),
                    onPressed: () {
                    
                      _togglePolylines();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}