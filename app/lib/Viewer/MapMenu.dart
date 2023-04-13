import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:es/Controller/MapMenuController.dart';

class MapMenu extends StatefulWidget {
  const MapMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MapMenu> createState() => _MapMenuState();
}

class _MapMenuState extends State<MapMenu> {
  late GoogleMapController mapController = MapMenuController().mapController;
  static final List<Marker> _marker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(widget.title,
            style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic)),
          centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
    onPressed: () {
    if (Navigator.canPop(context)) {
    Navigator.pop(context);
    }
    },
    ),),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(21.1458,79.2882),
          zoom: 14.0),
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller){
          MapMenuController().setMapController(controller);
        },
      )
    );
  }
}
