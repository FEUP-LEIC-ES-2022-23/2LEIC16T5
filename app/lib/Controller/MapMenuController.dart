import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapMenuController {
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(userInstance: FirebaseAuth.instance);
  late GoogleMapController mapController;
  Location location = Location();
  static final List<Marker> _markers = [];

  void setMapController(GoogleMapController controller){
    mapController = controller;
  }

  Future<LocationData> getCurrentLocation(BuildContext context) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

   _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error(
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Location services are disabled"));
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error(
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Location permissions are permanently denied"));
      }
    }

    var pos = await location.getLocation();
    return await pos;
  }

  List<Marker> getMarkers() {
    return _markers;
  }

  void addMarker(TransactionModel t) {
    Marker marker = Marker(
        markerId: MarkerId(t.transactionID!),
        position: LatLng(t.location!.latitude, t.location!.longitude),
        infoWindow: InfoWindow(
            title: t.name,
            snippet: '${t.total} €'
        )
    );
    _markers.add(marker);
  }

}