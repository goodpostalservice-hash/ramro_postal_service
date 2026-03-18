import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'navigation_service.dart';

class NaviagtionController extends GetxController {
  LatLng? currentLocation;
  Set<Polyline> polylines = <Polyline>{}.obs;
  Set<Marker> markers = <Marker>{}.obs;
  final Rx<DirectionsModel?> currentDirections = Rx<DirectionsModel?>(null);
  late GoogleMapController mapController;

  StreamSubscription? positionStream;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final loc = await LocationService.getCurrentLocation();
    currentLocation = loc;
    mapController.animateCamera(CameraUpdate.newLatLng(loc));
  }

  void fitBounds(LatLngBounds bounds) {
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  Future<void> startNavigation({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final directions = await NavigationService.getDirections(
      origin,
      destination,
    );
    if (directions == null) return;

    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.indigo,
        width: 5,
        points: directions.polylinePoints,
      ),
    };

    markers = {
      Marker(markerId: const MarkerId('origin'), position: origin),
      Marker(markerId: const MarkerId('destination'), position: destination),
    };

    currentDirections.value = directions;
    fitBounds(directions.bounds);
    _startTracking(directions);
    update();
  }

  void _startTracking(DirectionsModel directions) {
    positionStream?.cancel();
    positionStream = LocationService.locationStream().listen((position) {
      final current = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(current));
      currentLocation = current;

      if (!NavigationService.isOnRoute(current, directions.polylinePoints)) {
        startNavigation(
          origin: current,
          destination: directions.polylinePoints.last,
        );
      }
    });
  }

  String get estimatedArrivalTime {
    final now = DateTime.now();
    final direction = currentDirections.value;
    if (direction == null) return '--';

    final match = RegExp(r'(\d+)\s*min').firstMatch(direction.totalDuration);
    if (match != null) {
      final mins = int.parse(match.group(1)!);
      final arrival = now.add(Duration(minutes: mins));
      return '${arrival.hour}:${arrival.minute.toString().padLeft(2, '0')}';
    }
    return '--';
  }

  void recenterMap() {
    if (currentLocation != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
    update();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }
}

class DirectionsModel {
  final List<LatLng> polylinePoints;
  final LatLngBounds bounds;
  final List<String> instructions;
  final String totalDistance;
  final String totalDuration;
  final String nextStepDistance;
  final String nextStepInstruction;
  final String nextManeuverType;
  DirectionsModel({
    required this.nextStepDistance,
    required this.nextStepInstruction,
    required this.nextManeuverType,
    required this.polylinePoints,
    required this.bounds,
    required this.instructions,
    required this.totalDistance,
    required this.totalDuration,
  });
}

class LocationService {
  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  static Stream<Position> locationStream() => Geolocator.getPositionStream();
}
