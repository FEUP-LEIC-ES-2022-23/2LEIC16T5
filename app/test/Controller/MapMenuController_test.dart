import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:flutter/material.dart';
import 'package:es/Controller/MapMenuController.dart';

void main() {
  bool compareMarkers(Marker marker1, Marker marker2) {
    return marker1.markerId == marker2.markerId &&
        marker1.position.latitude == marker2.position.latitude &&
        marker1.position.longitude == marker2.position.longitude &&
        marker1.infoWindow.title == marker2.infoWindow.title &&
        marker1.infoWindow.snippet == marker2.infoWindow.snippet;
  }

  test('addMarker should add a marker to the markers list', () {
    MapMenuController mapUtils = MapMenuController();
    // Arrange
    final transaction = ExpenseModel(
        userID: '1',
        categoryID: null,
        transactionID: '1',
        name: 'Test Transaction',
        date: DateTime(0),
        location: GeoPoint(37.4220, -122.0841),
        total: 100,
        categoryColor: 111111);
    Marker expectedMarker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.4220, -122.0841),
      infoWindow: InfoWindow(
        title: 'Test Transaction',
        snippet: '100 €',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          HSVColor.fromColor(Color(111111)).hue),
    );

    // Act
    mapUtils.addMarker(transaction);

    // Assert
    expect(
      mapUtils
          .getMarkers()
          .any((marker) => compareMarkers(marker, expectedMarker)),
      isTrue,
    );
  });
}