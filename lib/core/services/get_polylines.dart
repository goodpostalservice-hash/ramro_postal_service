import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

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

    debugPrint('RoutePolylineHelper: No polyline points from API.');
    return const [];
  }

  // --- POLYLINE BUILDERS ---

  Polyline _createPolyline({
    required String id,
    required List<LatLng> points,
    required Color color,
    required int width,
    List<PatternItem>? patterns,
  }) {
    return Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: color,
      width: width,
      geodesic: true,
      patterns: patterns ?? const [],
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );
  }

  Polyline _buildDottedConnector({
    required String id,
    required LatLng point1,
    required LatLng point2,
    Color color = Colors.grey,
    int width = 6,
  }) {
    return _createPolyline(
      id: id,
      points: [point1, point2],
      color: color,
      width: width,
      // Google Maps typically uses a standard dot and gap for off-road connectors
      patterns: [PatternItem.dot, PatternItem.gap(20)],
    );
  }

  List<Polyline> buildLayeredPolyline({
    required String id,
    required List<LatLng> points,
    Color coreColor = const Color(0xFFFF910D),
    int borderWidth = 10, // Slightly thicker to match Google Maps
    int coreWidth = 6,
  }) {
    if (points.isEmpty) return [];

    return [
      _createPolyline(
        id: '${id}_border',
        points: points,
        color: Colors.white,
        width: borderWidth,
      ),
      _createPolyline(
        id: '${id}_core',
        points: points,
        color: coreColor,
        width: coreWidth,
      ),
    ];
  }

  List<Polyline> buildSegmentedLayeredPolyline({
    required String id,
    required List<LatLng> points,
    required List<Color> segmentColors,
    int borderWidth = 10,
    int coreWidth = 6,
  }) {
    if (points.isEmpty || segmentColors.isEmpty) return [];

    final List<Polyline> polylines = [];

    // 1. One continuous White border
    polylines.add(
      _createPolyline(
        id: '${id}_border',
        points: points,
        color: Colors.white,
        width: borderWidth,
      ),
    );

    // 2. Segmented core colors
    final int segmentSize = (points.length / segmentColors.length).ceil();

    for (int i = 0; i < segmentColors.length; i++) {
      final int start = (i * segmentSize).clamp(0, points.length);
      final int end = ((i + 1) * segmentSize).clamp(0, points.length);

      if (start >= end) break;

      List<LatLng> segmentPoints = points.sublist(start, end);

      // Overlap previous point to avoid gaps between segments
      if (i > 0 && start > 0) {
        segmentPoints.insert(0, points[start - 1]);
      }

      polylines.add(
        _createPolyline(
          id: '${id}_core_$i',
          points: segmentPoints,
          color: segmentColors[i],
          width: coreWidth,
        ),
      );
    }

    return polylines;
  }

  // --- BOUNDS & CAMERA ---

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

  /// Fits the route vertically (Origin at top, Destination at bottom)
  /// and dynamically adjusts the camera target based on the map's rotation
  /// so it centers perfectly in the empty UI space.
  Future<void> fitRouteVertically({
    required GoogleMapController? controller,
    required LatLngBounds? bounds,
    required Size screenSize,
    double topInsetFraction = 0.25,
    double bottomInsetFraction = 0.25,
    double sideInsetFraction = 0.05,
    double innerPaddingFactor = 0.90, // 10% margin inside the empty space
  }) async {
    if (controller == null || bounds == null) return;

    // 1. Calculate available empty space in pixels
    final double availableHeight =
        screenSize.height *
        (1 - topInsetFraction - bottomInsetFraction) *
        innerPaddingFactor;
    final double availableWidth =
        screenSize.width * (1 - 2 * sideInsetFraction) * innerPaddingFactor;

    // 2. Get bounds center and spans
    final double centerLat =
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
    final double centerLng =
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2;

    final double latSpan =
        (bounds.northeast.latitude - bounds.southwest.latitude).abs();
    final double lngSpan =
        (bounds.northeast.longitude - bounds.southwest.longitude).abs();

    // Fallback for single point
    if (latSpan < 1e-9 && lngSpan < 1e-9) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(centerLat, centerLng), 16),
      );
      return;
    }

    // 3. Convert spans to meters
    const double metersPerDegreeLat = 111320.0;
    final double centerLatRad = _degreesToRadians(centerLat);
    final double cosLat = math.cos(centerLatRad);

    final double latSpanMeters = latSpan * metersPerDegreeLat;
    final double lngSpanMeters = lngSpan * metersPerDegreeLat * cosLat;

    // 4. Calculate required zoom level to fit inside the empty space
    final double mppLat = latSpanMeters / availableHeight;
    final double mppLng = lngSpanMeters / availableWidth;
    final double requiredMpp = math.max(mppLat, mppLng);

    double zoom = 16.0;
    if (requiredMpp > 0) {
      // Formula: mpp = 156543.03392 * cos(lat) / 2^zoom
      zoom = (math.log(156543.03392 * cosLat / requiredMpp) / math.ln2).clamp(
        3.0,
        20.0,
      );
    }

    // 5. Calculate bearing (Origin at top, Destination at bottom)
    // We want the map's "Up" direction to point towards the Origin.
    // Assuming Southwest is destination-ish and Northeast is origin-ish for bearing calc,
    // but standard is to use the actual origin and destination.
    // Since we only have bounds here, we calculate bearing from South-West to North-East.
    // If you have exact origin/destination, pass them in. Assuming bounds center is fine.
    final double bearing = _calculateBearing(
      bounds.southwest,
      bounds.northeast,
    );

    // 6. Calculate the center of the visible empty space
    final double visibleCenterYFraction =
        topInsetFraction + (1 - topInsetFraction - bottomInsetFraction) / 2;

    // Difference between map's true center (0.5) and our desired empty space center
    final double dyFraction = 0.5 - visibleCenterYFraction;
    final double dyPixels = dyFraction * screenSize.height;

    // 7. Calculate ACTUAL geographic shift considering the map's bearing!
    // This is what makes it exactly like Google Maps. If the map is rotated 90 degrees,
    // shifting the camera "up" on screen means shifting it "East" geographically.
    final double actualMpp = 156543.03392 * cosLat / math.pow(2, zoom);
    final double distanceMeters = dyPixels * actualMpp;

    final double bearingRad = bearing * math.pi / 180.0;

    // Calculate latitude and longitude offsets based on bearing direction
    final double deltaLat =
        (distanceMeters * math.cos(bearingRad)) / metersPerDegreeLat;
    final double deltaLng =
        (distanceMeters * math.sin(bearingRad)) / (metersPerDegreeLat * cosLat);

    final double targetLat = centerLat + deltaLat;
    final double targetLng = centerLng + deltaLng;

    // 8. Animate camera
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(targetLat, targetLng),
          zoom: zoom,
          bearing: bearing,
        ),
      ),
    );
  }

  Future<RouteBuildResult> buildRoute({
    required String id,
    required LatLng origin,
    required LatLng destination,
    Color coreColor = const Color(0xFFFF910D),
    List<Color>? segmentColors,
    int borderWidth = 10,
    int coreWidth = 6,
    TravelMode travelMode = TravelMode.driving,
  }) async {
    final pts = await fetchRoutePoints(
      origin: origin,
      destination: destination,
      travelMode: travelMode,
    );

    final List<Polyline> polylines = [];

    // 1. Add the main driving route polylines
    if (pts.isNotEmpty) {
      if (segmentColors != null && segmentColors.isNotEmpty) {
        polylines.addAll(
          buildSegmentedLayeredPolyline(
            id: id,
            points: pts,
            segmentColors: segmentColors,
            borderWidth: borderWidth,
            coreWidth: coreWidth,
          ),
        );
      } else {
        polylines.addAll(
          buildLayeredPolyline(
            id: id,
            points: pts,
            coreColor: coreColor,
            borderWidth: borderWidth,
            coreWidth: coreWidth,
          ),
        );
      }
    }

    // 2. Add dotted connectors for off-road locations
    if (pts.isNotEmpty) {
      final firstRoadPoint = pts.first;
      final lastRoadPoint = pts.last;

      if (origin.latitude != firstRoadPoint.latitude ||
          origin.longitude != firstRoadPoint.longitude) {
        polylines.add(
          _buildDottedConnector(
            id: '${id}_origin_connector',
            point1: origin,
            point2: firstRoadPoint,
            color: appTheme.gray600,
          ),
        );
      }

      if (destination.latitude != lastRoadPoint.latitude ||
          destination.longitude != lastRoadPoint.longitude) {
        polylines.add(
          _buildDottedConnector(
            id: '${id}_dest_connector',
            point1: lastRoadPoint,
            point2: destination,
            color: appTheme.gray600,
          ),
        );
      }
    } else {
      // Fallback: If no road found at all, draw a straight dotted line
      polylines.add(
        _buildDottedConnector(
          id: '${id}_direct',
          point1: origin,
          point2: destination,
          color: appTheme.gray600,
        ),
      );
    }

    // 3. Compute bounds including the EXACT origin & destination
    final boundsPts = [...pts, origin, destination];
    final bounds = computeBounds(boundsPts);

    return RouteBuildResult(points: pts, polylines: polylines, bounds: bounds);
  }

  List<LatLng> _toLatLngList(List<PointLatLng> pts) =>
      pts.map((p) => LatLng(p.latitude, p.longitude)).toList();

  // --- MATH HELPERS ---

  double _degreesToRadians(double deg) => deg * math.pi / 180;
  double _radiansToDegrees(double rad) => rad * 180 / math.pi;

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = _degreesToRadians(start.latitude);
    final lon1 = _degreesToRadians(start.longitude);
    final lat2 = _degreesToRadians(end.latitude);
    final lon2 = _degreesToRadians(end.longitude);

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    final bearing = math.atan2(y, x);
    return (_radiansToDegrees(bearing) + 360.0) % 360.0;
  }
}

class RouteBuildResult {
  RouteBuildResult({
    required this.points,
    required this.polylines,
    required this.bounds,
  });

  final List<LatLng> points;
  final List<Polyline> polylines;
  final LatLngBounds? bounds;
}
