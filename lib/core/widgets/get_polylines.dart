import 'dart:math' as math;
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePolylineHelper {
  RoutePolylineHelper({required String apiKey})
    : _polylinePoints = PolylinePoints(apiKey: apiKey);

  final PolylinePoints _polylinePoints;

  Future<List<LatLng>> fetchRoutePoints({
    required LatLng origin,
    required LatLng destination,
    TravelMode travelMode = TravelMode.driving,
  }) async {
    final legacy = await _polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: travelMode,
      ),
    );

    if (legacy.errorMessage?.isNotEmpty == true) {
      debugPrint('Directions API error: ${legacy.errorMessage}');
    }

    if (legacy.points.isNotEmpty) {
      return _toLatLngList(legacy.points);
    }

    debugPrint('RoutePolylineHelper: No polyline points from either API.');
    return const [];
  }

  Polyline buildPolyline({
    required String id,
    required List<LatLng> points,
    Color color = const Color(0xFFFF910D),
    int width = 6,
    bool geodesic = true,
  }) {
    return Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: color,
      width: width,
      geodesic: geodesic,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );
  }

  LatLngBounds? computeBounds(List<LatLng> pts) {
    if (pts.isEmpty) return null;
    double minLat = pts.first.latitude, maxLat = minLat;
    double minLng = pts.first.longitude, maxLng = minLng;
    for (final p in pts) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> fitToBounds(
    GoogleMapController? controller,
    LatLngBounds? bounds, {
    double padding = 100,
  }) async {
    if (controller == null || bounds == null) return;
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  Future<RouteBuildResult> buildRoute({
    required String id,
    required LatLng origin,
    required LatLng destination,
    Color color = const Color(0xFFFF910D),
    int width = 6,
    TravelMode travelMode = TravelMode.driving,
  }) async {
    final pts = await fetchRoutePoints(
      origin: origin, // <-- use the passed args
      destination: destination, // <--
      travelMode: travelMode,
    );
    final polyline = buildPolyline(
      id: id,
      points: pts,
      color: color,
      width: width,
    );
    final bounds = computeBounds(pts);
    return RouteBuildResult(points: pts, polyline: polyline, bounds: bounds);
  }

  List<LatLng> _toLatLngList(List<PointLatLng> pts) =>
      pts.map((p) => LatLng(p.latitude, p.longitude)).toList();
}

class RouteBuildResult {
  RouteBuildResult({
    required this.points,
    required this.polyline,
    required this.bounds,
  });
  final List<LatLng> points;
  final Polyline polyline;
  final LatLngBounds? bounds;
}
