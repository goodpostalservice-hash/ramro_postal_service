import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';

import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../dashboard/presentation/widgets/address_dialog.dart';
import '../../domain/usecases/get_map_data_usecase.dart';
import '../pages/home_map_screen.dart';
import '../widgets/get_location_name.dart';
import 'house_marker_controller.dart';
import 'route_service.dart';

class HomeController extends GetxController {
  HomeController({
    required this.getMapDataUseCase,
    this.isShowSearchOnMap,
    HouseMarkerController? houseMarkerController,
    RouteService? routeService,
  }) : _routeService = routeService ?? RouteService() {
    _houseMarkerController =
        houseMarkerController ??
        HouseMarkerController(
          getMapDataUseCase: getMapDataUseCase,
          currentZoom: currentZoom,
          onMarkerTap: _handleHouseMarkerTap,
        );
  }

  final GetMapDataUseCase getMapDataUseCase;

  final RxDouble currentZoom = 15.0.obs;

  final Rx<LatLng> myCurrentLocation = Rx<LatLng>(
    HomeMapScreen.currentLocationAtStart ??
        const LatLng(27.7172, 85.3240), // Default fallback
  );

  final RxString myCurrentLocationName = ''.obs;
  bool? isShowSearchOnMap;
  final RxString myDestinationName = ''.obs;
  final RxBool isMyLocationButtonVisible = true.obs;

  final Rx<LatLng> destinationCoordinates = const LatLng(
    27.675859,
    85.351339,
  ).obs;

  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final RxSet<Marker> locationMarker = <Marker>{}.obs;

  final RxString selectedHouseTitle = ''.obs;
  final RxString selectedHouseSubtitle = ''.obs;

  final RouteService _routeService;
  late final HouseMarkerController _houseMarkerController;

  Set<Marker> get houseMarkers => _houseMarkerController.markers;

  GoogleMapController? get mapController =>
      _houseMarkerController.mapController;
  set mapController(GoogleMapController? controller) {
    _houseMarkerController.mapController = controller;
    _routeService.mapController = controller;
  }

  @override
  void onClose() {
    _houseMarkerController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _houseMarkerController.onMapCreated(controller);
  }

  void onCameraMove(CameraPosition position) {
    _houseMarkerController.onCameraMove(position);
  }

  void onCameraIdle() {
    _houseMarkerController.onCameraIdle();
  }

  Future<void> prepareSearchMap({
    required GoogleMapController controller,
    required LatLng target,
    required String highlightedLabel,
    String? forceLabelForTarget,
  }) {
    mapController = controller;
    return _houseMarkerController.prepareSearchMap(
      controller: controller,
      target: target,
      highlightedLabel: highlightedLabel,
      forceLabelForTarget: forceLabelForTarget,
    );
  }

  Future<void> onLongPressMap(
    LatLng latLng,
    String? fullAddress,
    String? addressSubtitle,
    BuildContext context,
  ) async {
    try {
      await getFreshLocation();
      myCurrentLocationName.value = await getGoogleLocationName(
        myCurrentLocation.value.latitude,
        myCurrentLocation.value.longitude,
      );
    } catch (e) {
      debugPrint('Error getting location/name: $e');
    }

    if (!context.mounted) return;
    setDestination(
      coordinates: latLng,
      name: fullAddress ?? '',
      subtitle: addressSubtitle ?? '',
    );

    showAddressDetailsDialog(
      context,
      destinationLocation: latLng,
      onPlaceOrder: () {},
      address: fullAddress,
      addressSubtitle: addressSubtitle,
      mapPreview: Image.asset(
        'assets/images/default_map_preview.png',
        fit: BoxFit.cover,
      ),
      onGetDirection: () {
        try {
          Get.find<DashboardController>().showBottomNav.value = false;
        } catch (_) {
          debugPrint('DashboardController not found in dependency tree');
        }

        drawRoute(myCurrentLocation.value, latLng);
        Navigator.pop(context);
      },
      onClose: () {
        polylines.clear();
        locationMarker.clear();
        Navigator.pop(context);
      },
    );
  }

  Future<void> drawRoute(LatLng origin, LatLng destination) {
    return _routeService.drawRoute(
      origin: origin,
      destination: destination,
      polylines: polylines,
      locationMarkers: locationMarker,
    );
  }

  /// Updates every destination field together so labels and navigation
  /// coordinates cannot refer to different places.
  void setDestination({
    required LatLng coordinates,
    required String name,
    String? title,
    String subtitle = '',
  }) {
    destinationCoordinates.value = coordinates;
    myDestinationName.value = name.trim();
    selectedHouseTitle.value = (title ?? name).trim();
    selectedHouseSubtitle.value = subtitle.trim();
  }

  void clearDestination() {
    myDestinationName.value = '';
    selectedHouseTitle.value = '';
    selectedHouseSubtitle.value = '';
    polylines.clear();
    locationMarker.clear();
  }

  Future<void> fetchHouseNumbersOptimized() {
    return _houseMarkerController.fetchHouseNumbersOptimized();
  }

  Future<bool> getFreshLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    myCurrentLocation.value = LatLng(position.latitude, position.longitude);
    return true;
  }

  void recenterMap() {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(myCurrentLocation.value, 19),
    );
  }

  Future<void> _handleHouseMarkerTap(
    LatLng location,
    String? fullAddress,
    String label,
    String? zone,
    String? subZone,
    String markerId, // Added ID parameter
  ) async {
    // 1. Update the map highlight using the unique ID
    _houseMarkerController.updateHighlight(markerId);

    // 2. Branch logic based on screen type
    if (isShowSearchOnMap == true) {
      // --- SEARCH MAP SCREEN BEHAVIOR ---
      selectedHouseTitle.value = fullAddress?.isNotEmpty == true
          ? splitCoordinateString(fullAddress!)
          : label;

      final zoneStr = zone?.trim() ?? '';
      final subZoneStr = subZone?.trim() ?? '';
      String subtitle = '';

      if (zoneStr.isNotEmpty && subZoneStr.isNotEmpty) {
        subtitle = '$zoneStr, $subZoneStr';
      }

      if (subtitle.isEmpty) {
        subtitle = selectedHouseSubtitle.value;
      }

      selectedHouseSubtitle.value = subtitle;
    } else {
      // --- HOME MAP SCREEN BEHAVIOR ---
      final zoneStr = zone?.trim() ?? '';
      final subZoneStr = subZone?.trim() ?? '';
      String subtitle = '';

      if (zoneStr.isNotEmpty && subZoneStr.isNotEmpty) {
        subtitle = '$zoneStr, $subZoneStr';
      }

      if (subtitle.isEmpty) {
        subtitle = selectedHouseSubtitle.value;
      }

      selectedHouseSubtitle.value = subtitle;
      final context = Get.context;
      if (context == null) return;
      await onLongPressMap(
        location,
        fullAddress,
        selectedHouseSubtitle.value,
        context,
      );
    }
  }
}
