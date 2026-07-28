import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/services/get_polylines.dart';

class RouteService {
  RouteService({String? apiKey})
    : _helper = RoutePolylineHelper(apiKey: apiKey ?? AppConstant.googleMapAPI);

  final RoutePolylineHelper _helper;
  GoogleMapController? mapController;

  Future<void> drawRoute({
    required LatLng origin,
    required LatLng destination,
    required RxSet<Polyline> polylines,
    required Set<Marker> locationMarkers,
  }) async {
    try {
      final result = await _helper.buildRoute(
        id: 'route-1',
        origin: origin,
        destination: destination,
        travelMode: TravelMode.driving,
        segmentColors: [appTheme.orangeBase, Colors.blue],
        borderWidth: 10,
        coreWidth: 6,
      );

      polylines
        ..clear()
        ..addAll(result.polylines);

      locationMarkers
        ..clear()
        ..add(Marker(markerId: const MarkerId('start'), position: origin))
        ..add(Marker(markerId: const MarkerId('end'), position: destination));

      // await _helper.fitToBounds(mapController, result.bounds, padding: 25);
      final size = MediaQuery.of(Get.context!).size;

      _helper.fitRouteVertically(
        controller: mapController,
        bounds: result.bounds,
        screenSize: size,
        topInsetFraction: 0.25, // Top widget takes 25%
        bottomInsetFraction: 0.25, // Bottom widget takes 25%
      );
    } catch (error) {
      debugPrint('Failed to draw route: $error');
    }
  }
}
