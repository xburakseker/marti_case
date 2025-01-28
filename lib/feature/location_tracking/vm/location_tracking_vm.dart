import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:marti_case/core/extension/context_extension.dart';
import 'package:marti_case/core/utils/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:geocoding/geocoding.dart';

final class LocationTrackingVm extends BaseViewModel {
  GoogleMapController? mapController;
  Position? currentPosition;
  Set<Marker> markers = {};
  Box? locationBox;
  StreamSubscription<Position>? positionStream;
  bool isTracking = false;

  LocationTrackingVm(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    locationBox = await Hive.openBox('locationBox');
    await _loadMarkers();
    try {
      await PermissionHandler.checkPermissions();
    } catch (e) {
      context.showPermissionError(e.toString());
    }
  }

  Future<void> _loadMarkers() async {
    final storedMarkers = locationBox?.get('markers') ?? [];
    markers = storedMarkers.map<Marker>((markerData) {
      return Marker(
        markerId: MarkerId(markerData['id']),
        position: LatLng(markerData['lat'], markerData['lng']),
        infoWindow: InfoWindow(title: markerData['address'], snippet: markerData['snippet']),
      );
    }).toSet();
    notifyListeners();
  }

  Future<void> _saveMarker(Marker marker) async {
    final storedMarkers = locationBox?.get('markers') ?? [];
    storedMarkers.add({
      'id': marker.markerId.value,
      'lat': marker.position.latitude,
      'lng': marker.position.longitude,
      'address': marker.infoWindow.title,
      'snippet': marker.infoWindow.snippet,
    });
    await locationBox?.put('markers', storedMarkers);
  }

  Future<Marker> _createMarker(Position position) async {
    final address = await getAddress(LatLng(position.latitude, position.longitude));
    return Marker(
      markerId: MarkerId(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Konum', snippet: address),
    );
  }

  Future<String> getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      return address;
    } catch (e) {
      print(e);
      return 'Adres bulunamadı';
    }
  }

  void startTracking(Function(String e) dialog) async {
    try {
      await PermissionHandler.checkPermissions();
      isTracking = true;
      notifyListeners();
      positionStream?.cancel();
      positionStream = Geolocator.getPositionStream().listen((position) async {
        final distance = Geolocator.distanceBetween(
          currentPosition?.latitude ?? 0.0,
          currentPosition?.longitude ?? 0.0,
          position.latitude,
          position.longitude,
        );
        if (distance >= 100) {
          currentPosition = position;
          _updateCameraPosition(position);
          final marker = await _createMarker(position);
          markers.add(marker);
          await _saveMarker(marker);
          notifyListeners();
        }
      });
    } catch (e) {
      dialog(e.toString());
      isTracking = false;
      notifyListeners();
    }
  }

  void _updateCameraPosition(Position position) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }
  }

  void stopTracking() {
    isTracking = false;
    positionStream?.cancel();
    positionStream = null;
    notifyListeners();
  }

  void resetRoute() async {
    await locationBox?.put('markers', []);
    markers.clear();
    notifyListeners();
  }
}
