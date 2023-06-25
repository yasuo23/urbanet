import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String adress;

  map({required this.latitude, required this.longitude, required this.adress});

  @override
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<map> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    LatLng markerLatLng = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: markerLatLng,
          zoom: 15.0,
        ),
        markers: Set<Marker>.from([
          Marker(
              markerId: MarkerId('marker'),
              position: markerLatLng,
              infoWindow: InfoWindow(
                title: widget.adress,
              )),
        ]),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
