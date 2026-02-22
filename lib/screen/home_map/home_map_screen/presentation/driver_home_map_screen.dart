import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/widgets/get_polylines.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/controller/home_driver_map_controller.dart';
import 'package:ramro_postal_service/screen/main/controller/dashboard_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/presentation/pages/saved_address_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vibration/vibration.dart';
import '../../../search/presentation/view/google_search_screen.dart';
import 'widgets/address_dialog.dart';
import 'widgets/home_bottom_panel.dart';
import 'widgets/map_type_setting.dart';

class DriverHomeMapScreen extends StatefulWidget {
  const DriverHomeMapScreen({super.key});
  static LatLng? currentLocationAtStart;

  @override
  State<DriverHomeMapScreen> createState() => _DriverHomeMapScreenState();
}

class _DriverHomeMapScreenState extends State<DriverHomeMapScreen> {
  // --- State ---
  LatLng? myDestinationLocation;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController; // NOTE: safer nullable field

  final Set<Polyline> _polylines = <Polyline>{};

  static const double _defaultZoom = 17.0;
  static const double _minZoom = 10.0;
  static const double _maxZoom = 21.0;
  static const double _labelZoomThreshold = 20.0;

  MapType _selectedMapType = MapType.normal;

  // Markers cache to avoid refetching on tiny camera moves
  final Map<String, List<LabelMarker>> _markerCache =
      <String, List<LabelMarker>>{};

  // Debounce camera idle
  Timer? _debounceTimer;
  LatLngBounds? _lastVisibleBounds;
  double _lastZoomLevel = _defaultZoom;

  // Saved Address UI State
  String? _selectedValue;
  final List<String> _dropdownValues = const ['Home', 'Work', 'Other'];
  final bool _isDefaultChecked = false;

  // Online switch
  bool _isOnline = true;

  bool isButtonSheetbuttonSelected = false;

  // Controllers
  final driverHouseListController = Get.put(HomeDriverMapController());
  final TextEditingController addressTypeController = TextEditingController();
  final TextEditingController addressKnownTypeController =
      TextEditingController();
  final _helper = RoutePolylineHelper(apiKey: AppConstant.googleMapAPI);
  // Lifecycle hook to clear Map style (fix white tiles after resume)
  String? _lifecycleHandler(String? msg) {
    if (msg == AppLifecycleState.resumed.toString()) {
      _mapController?.setMapStyle("[]");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    driverHouseListController.driverMarker.clear();
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      _lifecycleHandler(msg);
      return null;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    addressTypeController.dispose();
    addressKnownTypeController.dispose();
    driverHouseListController.driverMarker.clear();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _openMapSettings() async {
    final chosen = await showMapSettingsSheet(
      context,
      initial: _selectedMapType,
      standardThumb: Assets.mapStandard,
      satelliteThumb: Assets.mapSatellite,
      hybridThumb: Assets.mapHybrid,
    );
    if (!mounted) return;
    if (chosen != null) {
      setState(() => _selectedMapType = chosen);
    }
  }

  final dashboardController = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        minAppVersion: "1.0.3",
        durationUntilAlertAgain: const Duration(hours: 2),
      ),
      child: Obx(
        () => SafeArea(
          child: Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: appTheme.white,
                systemNavigationBarColor: appTheme.white,
              ),
              child: Stack(
                children: [
                  _googleMap(),
                  dashboardController.showBottomNav.value == false
                      ? SafeArea(
                          child: Container(
                            color: appTheme.gray25,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _LocationTile(
                                    title: 'Live location',
                                    subtitle: driverHouseListController
                                        .myCurrentLocationName
                                        .value,
                                    leading: _Dot(color: Color(0xFFFF5A5F)),
                                  ),
                                  SizedBox(height: 10),
                                  _LocationTile(
                                    title: 'Destination location',
                                    subtitle: driverHouseListController
                                        .myDestinationName
                                        .value,
                                    leading: _RoundedIcon(
                                      icon: Icons.place_rounded,
                                      iconColor: Color(0xFF17A34A),
                                      bgColor: Color(0xFFEFF8F1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 125.0,
                          color: appTheme.white,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top - 6.0,
                            left: getHorizontalSize(16.0),
                            right: getHorizontalSize(16.0),
                            bottom: 8.0,
                          ),
                          child: SearchPanel(
                            suggestions: const ['Civil Hospital', 'Pulchowk'],
                            onTap: () => Get.to(const GoogleSearchScreen()),
                            readOnly: true,
                          ),
                        ),
                  _mapTypeButton(),
                  _myLocationButton(),
                  dashboardController.showBottomNav.value == false
                      ? BottomPanel(
                          addressTitle:
                              driverHouseListController.myDestinationName.value,
                          addressSubtitle: 'Nepal   ·   Kathmandu 44600',
                          onNavigate: () {},
                          onSave: () {},
                          onShare: () {},
                          onClose: () {
                            final dashboardController =
                                Get.find<DashboardController>();
                            dashboardController.showBottomNav.value = true;
                            _polylines.clear();
                            driverHouseListController.locationMarker.clear();
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -- Google Map -------------------------------------------------------------

  Widget _googleMap() {
    final me = driverHouseListController.myCurrentLocation.value;

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(me.latitude, me.longitude),
        zoom: _defaultZoom,
      ),
      markers: {
        ...driverHouseListController.driverMarker,
        ...driverHouseListController.locationMarker,
      },
      polylines: _polylines,
      mapType: _selectedMapType,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(_minZoom, _maxZoom),
      trafficEnabled: true,

      // Interactions
      onLongPress: _onLongPressMap,
      onCameraMove: (pos) {
        driverHouseListController.center.value = pos.target;
        driverHouseListController.currentZoom.value = pos.zoom;
      },
      onCameraIdle: _onCameraIdle,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _mapController = controller;
  }

  // -- UI Top Strip -----------------------------------------------------------

  Widget _topMenu() {
    return Container(
      color: AppColors.yellowColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.0,
        left: 12.0,
        right: 12.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          CustomSwitchButton(
            initialValue: _isOnline,
            onChanged: (v) => setState(() {
              _isOnline = v;
              if (_isOnline) _showOnlineNotification();
            }),
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 25.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoogleSearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // -- Map Type Selector ------------------------------------------------------

  Positioned _mapTypeButton() {
    return Positioned(
      bottom: 250,
      right: 8,
      child: GestureDetector(
        onTap: () => _openMapSettings(),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: _floatingBoxDecoration(),
          child: SvgPicture.asset(
            'assets/icons/svg/map_type.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // -- My Location Button -----------------------------------------------------

  Positioned _myLocationButton() {
    return Positioned(
      bottom: 180,
      right: 8,
      child: Visibility(
        visible: driverHouseListController.isMyLocationButtonVisible.value,
        child: GestureDetector(
          onTap: _animateToMyLocation,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: _floatingBoxDecoration(),
            child: SvgPicture.asset(
              'assets/icons/svg/vector.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _floatingBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24.0),
    border: Border.all(color: appTheme.gray50, width: 1.0),
    boxShadow: const [
      BoxShadow(
        color: Color(0x59000000), // #00000059 (≈35% opacity black)
        offset: Offset(0, 0.5), // x=0px, y=0.5px
        blurRadius: 1.5, // 1.5px blur
        spreadRadius: 0, // 0px spread
      ),
    ],
  );

  Future<void> _animateToMyLocation() async {
    final me = driverHouseListController.myCurrentLocation.value;
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(me.latitude, me.longitude), 19.0),
    );
  }

  Future<void> _onLongPressMap(LatLng latLng) async {
    await driverHouseListController.getFreshLocation();
    driverHouseListController.myCurrentLocationName.value =
        await getCurrentLocationName(
          driverHouseListController.myCurrentLocation.value.latitude,
          driverHouseListController.myCurrentLocation.value.longitude,
        );
    driverHouseListController.destinationCoordinates.value = latLng;
    showAddressDetailsDialog(
      context,
      destinationLocation: latLng,
      address: await getCurrentLocationName(latLng.latitude, latLng.longitude),
      mapPreview: Image.network(
        'https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png', // replace with your static map
        fit: BoxFit.cover,
      ),
      onGetDirection: () {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.showBottomNav.value = false;
        _drawRoute(
          LatLng(
            driverHouseListController.myCurrentLocation.value.latitude,
            driverHouseListController.myCurrentLocation.value.longitude,
          ),
          latLng,
        );
        Navigator.pop(context);
        // Get.to(
        //   () => RoutePreviewScreen(
        //     origin: driverHouseListController.myCurrentLocation.value,
        //     destination: latLng,
        //   ),
        // );
      },
    );
    // try {
    //   final iconFuture = _destinationIcon();
    //   final refreshFuture = driverHouseListController.getFreshLocation();
    //   final customIcon = await iconFuture;
    //   await refreshFuture;

    //   driverHouseListController.locationMarker.add(
    //     Marker(
    //       markerId: const MarkerId('destination_marker'),
    //       position: latLng,
    //       icon: customIcon,
    //       draggable: true,
    //     ),
    //   );

    //   // Non-blocking vibration
    //   unawaited(() async {
    //     try {
    //       if (await Vibration.hasCustomVibrationsSupport()) {
    //         await Vibration.vibrate(duration: 100, amplitude: -2);
    //       } else {
    //         await Vibration.vibrate();
    //         await Future.delayed(const Duration(milliseconds: 100));
    //         await Vibration.vibrate();
    //       }
    //     } catch (_) {}
    //   }());

    //   // Compute bounds (current <-> new dest)
    //   final cur = driverHouseListController.myCurrentLocation.value;
    //   final start = LatLng(cur.latitude, cur.longitude);
    //   final end = latLng;

    //   final bounds = LatLngBounds(
    //     southwest: LatLng(
    //       min(start.latitude, end.latitude),
    //       min(start.longitude, end.longitude),
    //     ),
    //     northeast: LatLng(
    //       max(start.latitude, end.latitude),
    //       max(start.longitude, end.longitude),
    //     ),
    //   );

    //   final cameraFuture = _mapController?.animateCamera(
    //     CameraUpdate.newLatLngBounds(bounds, 170),
    //   );

    //   final addr = await Future.wait([
    //     getCurrentLocationName(start.latitude, start.longitude),
    //     getCurrentLocationName(end.latitude, end.longitude),
    //   ]);

    //   await cameraFuture;

    //   if (!mounted) return;
    //   _showAddressActionSheet(
    //     currentAddress: addr[0],
    //     destinationAddress: addr[1],
    //     destLatLng: latLng,
    //     isGoogleAddress: true,
    //     isFromMarker: false,
    //   );
    // } catch (e) {
    //   showErrorMessage(e.toString());
    // }
  }

  Future<BitmapDescriptor> _destinationIcon() {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      ImageConstant.currentLocationPng,
    );
  }

  // Camera idle: label fetch / cache / debounce
  Future<void> _onCameraIdle() async {
    final controller = _mapController;
    if (controller == null) return;

    final zoom = await controller.getZoomLevel();
    if (zoom >= _labelZoomThreshold) {
      _scheduleLabelUpdate();
    } else {
      _debounceTimer?.cancel();
      // remove labels smoothly after short delay
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        final stillLowZoom = (_mapController != null);
        if (stillLowZoom && zoom < _labelZoomThreshold) {
          driverHouseListController.driverMarker.clear();
          setState(() {});
        }
      });
    }
  }

  void _scheduleLabelUpdate() async {
    final controller = _mapController;
    if (controller == null) return;

    final bounds = await controller.getVisibleRegion();
    final zoom = await controller.getZoomLevel();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      if (_shouldFetchNewMarkers(bounds, zoom)) {
        final cached = _readCache(bounds);
        if (cached != null) {
          _applyMarkers(cached);
          _lastVisibleBounds = bounds;
          _lastZoomLevel = zoom;
          return;
        }
        final fetched = await _fetchMarkers(bounds);
        _writeCache(bounds, fetched);
        _applyMarkers(fetched);
        _lastVisibleBounds = bounds;
        _lastZoomLevel = zoom;
      }
    });
  }

  bool _shouldFetchNewMarkers(LatLngBounds currentBounds, double zoom) {
    if (_lastVisibleBounds == null) return zoom >= _labelZoomThreshold;
    return zoom >= _labelZoomThreshold &&
        (zoom != _lastZoomLevel ||
            !_boundsContainsWithTolerance(
              currentBounds,
              _lastVisibleBounds!,
              0.2,
            ));
  }

  bool _boundsContainsWithTolerance(
    LatLngBounds parent,
    LatLngBounds child,
    double tolerance,
  ) {
    final requiredCoverage = 1.0 - tolerance;

    final parentArea =
        (parent.northeast.latitude - parent.southwest.latitude) *
        (parent.northeast.longitude - parent.southwest.longitude);

    final south = max(parent.southwest.latitude, child.southwest.latitude);
    final north = min(parent.northeast.latitude, child.northeast.latitude);
    final west = max(parent.southwest.longitude, child.southwest.longitude);
    final east = min(parent.northeast.longitude, child.northeast.longitude);

    if (south >= north || west >= east) return false;

    final overlappingArea = (north - south) * (east - west);
    return (overlappingArea / parentArea) >= requiredCoverage;
  }

  String _cacheKey(LatLngBounds b) =>
      '${b.northeast.latitude}_${b.northeast.longitude}_${b.southwest.latitude}_${b.southwest.longitude}';

  List<LabelMarker>? _readCache(LatLngBounds b) => _markerCache[_cacheKey(b)];

  void _writeCache(LatLngBounds b, List<LabelMarker> m) =>
      _markerCache[_cacheKey(b)] = m;

  Future<List<LabelMarker>> _fetchMarkers(LatLngBounds bounds) async {
    final centerLat =
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    final centerLng =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;

    final List<MapModel> found = await driverHouseListController.getHouseList(
      centerLat,
      centerLng,
    );

    Color textColor =
        (_selectedMapType == MapType.normal ||
            _selectedMapType == MapType.terrain)
        ? Colors.black45
        : Colors.white;
    Color shadowColor =
        (_selectedMapType == MapType.normal ||
            _selectedMapType == MapType.terrain)
        ? Colors.transparent
        : Colors.black87;

    return found
        .map(
          (address) => LabelMarker(
            visible: true,
            onTap: () async {
              await driverHouseListController.getFreshLocation();

              driverHouseListController.myCurrentLocationName.value =
                  await getCurrentLocationName(
                    driverHouseListController.myCurrentLocation.value.latitude,
                    driverHouseListController.myCurrentLocation.value.longitude,
                  );

              showAddressDetailsDialog(
                context,
                destinationLocation: LatLng(
                  double.parse(address.latitude!),
                  double.parse(address.longitude!),
                ),
                address: splitCoordinateString(address.fullAddressDetail!),
                mapPreview: Image.network(
                  'https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png', // replace with your static map
                  fit: BoxFit.cover,
                ),
                onGetDirection: () {
                  final dashboardController = Get.find<DashboardController>();
                  dashboardController.showBottomNav.value = false;
                  _drawRoute(
                    LatLng(
                      driverHouseListController
                          .myCurrentLocation
                          .value
                          .latitude,
                      driverHouseListController
                          .myCurrentLocation
                          .value
                          .longitude,
                    ),
                    LatLng(
                      double.parse(address.latitude!),
                      double.parse(address.longitude!),
                    ),
                  );
                  Navigator.pop(context);
                  // Get.to(
                  //   () => RoutePreviewScreen(
                  //     origin: driverHouseListController.myCurrentLocation.value,
                  //     destination: latLng,
                  //   ),
                  // );
                },
              );
              // _showAddressActionSheet(
              //   currentAddress: initAddress,
              //   destinationAddress: address.fullAddressDetail ?? '',
              //   destLatLng: LatLng(
              //     double.parse(address.latitude!),
              //     double.parse(address.longitude!),
              //   ),
              //   isGoogleAddress: false,
              //   isFromMarker: true,
              // );
            },
            label: "${address.houseNum ?? ''} ${address.subZone ?? ''}",
            textStyle: TextStyle(
              color: textColor,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              inherit: true,
              shadows: [
                Shadow(offset: const Offset(-1.5, -1.5), color: shadowColor),
                Shadow(offset: const Offset(1.5, -1.5), color: shadowColor),
                Shadow(offset: const Offset(1.5, 1.5), color: shadowColor),
                Shadow(offset: const Offset(-1.5, 1.5), color: shadowColor),
              ],
            ),
            markerId: MarkerId(
              "${address.houseNum ?? ''} ${address.subZone ?? ''}",
            ),
            position: LatLng(
              double.parse(address.latitude!),
              double.parse(address.longitude!),
            ),
            backgroundColor: Colors.transparent,
          ),
        )
        .toList();
  }

  void _applyMarkers(List<LabelMarker> newMarkers) {
    if (!mounted) return;

    final currentIds = driverHouseListController.driverMarker
        .map((m) => m.markerId)
        .toSet();
    for (final marker in newMarkers) {
      if (!currentIds.contains(marker.markerId)) {
        driverHouseListController.driverMarker.addLabelMarker(marker);
      }
    }
    setState(() {});
  }

  Future<void> _drawRoute(LatLng origin, LatLng destination) async {
    final result = await _helper.buildRoute(
      id: 'route-1',
      origin: origin,
      destination: destination,
      travelMode: TravelMode.driving,
      // googleApiKey: '…', // optional if needed by your setup
      color: const Color(0xFFFF910D),
      width: 8,
    );

    setState(() {
      _polylines
        ..clear()
        ..add(result.polyline);

      driverHouseListController.locationMarker
        ..clear()
        ..add(Marker(markerId: const MarkerId('start'), position: origin))
        ..add(Marker(markerId: const MarkerId('end'), position: destination));
    });

    await _helper.fitToBounds(_mapController, result.bounds, padding: 130);
  }

  // -- Save Address Dialog ----------------------------------------------------

  // void _showSaveAddressDialog(LatLng latLng, String destinationAddress) {
  //   final driver = Get.find<HomeDriverMapController>();
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         insetPadding: const EdgeInsets.all(10),
  //         contentPadding: const EdgeInsets.all(15),
  //         content: StatefulBuilder(
  //           builder: (_, setState) {
  //             return Obx(
  //               () => SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const Padding(
  //                       padding: EdgeInsets.only(bottom: 10),
  //                       child: Text(
  //                         '- Select To Continue -',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                     // Type
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 12),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.grey[300]!,
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: DropdownButtonHideUnderline(
  //                         child: DropdownButton<String>(
  //                           hint: const Text('Select Address Type'),
  //                           value: _selectedValue,
  //                           items: _dropdownValues
  //                               .map(
  //                                 (e) => DropdownMenuItem(
  //                                   value: e,
  //                                   child: Text(e),
  //                                 ),
  //                               )
  //                               .toList(),
  //                           onChanged: (v) =>
  //                               setState(() => _selectedValue = v),
  //                         ),
  //                       ),
  //                     ),
  //                     // Name
  //                     Container(
  //                       margin: const EdgeInsets.only(top: 20),
  //                       padding: const EdgeInsets.only(left: 2),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.grey[300]!,
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: TextFormField(
  //                         controller: addressTypeController,
  //                         decoration: const InputDecoration(
  //                           hintText: 'eg. Address name',
  //                           contentPadding: EdgeInsets.symmetric(
  //                             horizontal: 10,
  //                           ),
  //                           border: InputBorder.none,
  //                         ),
  //                       ),
  //                     ),
  //                     // Default
  //                     Container(
  //                       margin: const EdgeInsets.symmetric(vertical: 20),
  //                       padding: const EdgeInsets.only(left: 2),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.grey[300]!,
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: CheckboxListTile(
  //                         title: const Text(
  //                           'Set As Default Address',
  //                           style: TextStyle(fontSize: 15),
  //                         ),
  //                         value: _isDefaultChecked,
  //                         onChanged: (v) =>
  //                             setState(() => _isDefaultChecked = v ?? false),
  //                       ),
  //                     ),
  //                     // Buttons
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () => Navigator.of(context).pop(),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.grey[300],
  //                           ),
  //                           child: const SizedBox(
  //                             height: 50,
  //                             child: Center(
  //                               child: Text(
  //                                 'Cancel',
  //                                 style: TextStyle(color: Colors.black54),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 10),
  //                         ElevatedButton(
  //                           onPressed: () async {
  //                             await driver.saveQR(
  //                               latLng.longitude.toString(),
  //                               latLng.latitude.toString(),
  //                               destinationAddress,
  //                               addressTypeController.text.isEmpty
  //                                   ? _selectedValue
  //                                   : addressTypeController.text,
  //                               _isDefaultChecked,
  //                             );
  //                             Get.put(SavedAddressController());
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: AppColors.primary,
  //                           ),
  //                           child: SizedBox(
  //                             height: 50,
  //                             child: Center(
  //                               child: driver.isLoading.value
  //                                   ? const SizedBox(
  //                                       width: 20,
  //                                       height: 20,
  //                                       child: CircularProgressIndicator(
  //                                         color: Colors.white,
  //                                         strokeWidth: 2,
  //                                       ),
  //                                     )
  //                                   : const Text(
  //                                       'Save',
  //                                       style: TextStyle(color: Colors.white),
  //                                     ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // -- Share ------------------------------------------------------------------

  void _shareRideDetails(BuildContext context, String address) {
    final box = context.findRenderObject() as RenderBox?;
    final rideAdd = _stripLatLng(address);
    Share.share(
      "Hey, I'm sharing my  location. Please search this address:$rideAdd \n https://play.google.com/store/apps/details?id=com.gps.ramro_postal_service",
      subject: 'My Address',
      sharePositionOrigin: box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : const Rect.fromLTWH(0, 0, 0, 0),
    );
  }

  String _stripLatLng(String address) {
    final parts = address.split(',');
    if (parts.length <= 2) return address;
    return parts.sublist(0, parts.length - 2).join(',');
  }

  // -- Driver Online Notification (placeholder) -------------------------------

  void _showOnlineNotification() async {
    // left intentionally as a placeholder; your original impl was commented
  }
}

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.label,
  });

  final VoidCallback onTap;
  final String imagePath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: SvgPicture.asset(imagePath, color: Colors.white, width: 25),
        label: Text(label, style: AppFonts.robotoRegular),
      ),
    );
  }
}

class IconAndAddressWidget extends StatelessWidget {
  const IconAndAddressWidget({
    super.key,
    required this.address,
    required this.isGoogleAddress,
    required this.addressType,
    required this.isFromMarker,
  });

  final String address;
  final bool isGoogleAddress;
  final String addressType;
  final bool isFromMarker;

  @override
  Widget build(BuildContext context) {
    final isCurrent = addressType == 'Current Location';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Container(
              color: isCurrent ? const Color(0xFF9CC5FA) : Colors.red[100],
              padding: const EdgeInsets.all(3),
              height: 40,
              width: 40,
              child: SvgPicture.asset(
                isCurrent
                    ? ImageConstant.currentLocation
                    : ImageConstant.destinationLocation,
                fit: BoxFit.contain,
                color: isCurrent ? const Color(0xFF2563EB) : Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Text(
                  (isGoogleAddress || isFromMarker)
                      ? address
                      : _stripLatLng(address),
                  style: AppFonts.robotoRegular.copyWith(color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: Text(
                  addressType,
                  style: AppFonts.robotoThin.copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _stripLatLng(String address) {
    final parts = address.split(',');
    if (parts.length <= 2) return address;
    return parts.sublist(0, parts.length - 2).join(',');
  }
}

class MapTypeOption {
  final String name;
  final MapType mapType;
  const MapTypeOption(this.name, this.mapType);
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.title,
    required this.subtitle,
    required this.leading,
  });

  final String title;
  final String subtitle;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final border = const Color(0xFFE6E6E6);
    final textPrimary = const Color(0xFF101010);
    final textSecondary = const Color(0xFF6C6C6C);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _RoundedIcon extends StatelessWidget {
  const _RoundedIcon({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}
