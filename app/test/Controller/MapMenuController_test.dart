import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:es/Model/ExpenseModel.dart';
import 'package:es/Controller/MapMenuController.dart';

void main() {
  test('addMarker should add a marker to the markers list', () {
    MapMenuController mapUtils = MapMenuController();
    // Arrange
    final transaction = ExpenseModel(
      userID: '1',
      categoryID: "test category",
      transactionID: '1',
      name: 'Test Transaction',
      date: DateTime(0),
      location: GeoPoint(37.4220, -122.0841),
      total: 100,
    );
    const expectedMarker =  Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.4220, -122.0841),
      infoWindow: InfoWindow(
        title: 'Test Transaction',
        snippet: '100 €',
      ),
    );

    // Act
    mapUtils.addMarker(transaction);

    // Assert
    expect(mapUtils.getMarkers(), contains(expectedMarker));
  });
}