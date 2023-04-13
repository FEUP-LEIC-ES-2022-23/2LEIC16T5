import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapMenuController {
  late GoogleMapController mapController;

  void setMapController(GoogleMapController controller){
    mapController = controller;
  }

  Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return Future.error(
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Location services are disabled"));
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error(
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Location permissions are denied"));
      }
    }
    if (permission == LocationPermission.deniedForever){
      return Future.error(
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Location permissions are permanently denied"));
    }

    return await Geolocator.getCurrentPosition();
  }
}