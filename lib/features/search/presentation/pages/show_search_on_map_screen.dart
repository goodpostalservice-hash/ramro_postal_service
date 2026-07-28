import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../routes/app_routes.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../home/presentation/widgets/home_bottom_panel.dart';
import '../../../home/presentation/widgets/map_type_setting.dart';

class ShowSearchOnMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final String street;
  final String zone;
  final String sub;
  final String houseno;
  final String locationName;

  const ShowSearchOnMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.houseno,
    required this.street,
    required this.zone,
    required this.sub,
    required this.locationName,
  });

  @override
  State<ShowSearchOnMapScreen> createState() => _ShowSearchOnMapScreenState();
}

class _ShowSearchOnMapScreenState extends State<ShowSearchOnMapScreen> {
  late final HomeController houseController;
  late final LatLng _target;
  late final String _addressTitle;
  late final String _addressSubtitle;
  late final String _shareAddress;

  GoogleMapController? _mapController;
  MapType _selectedMapType = MapType.normal;

  @override
  void initState() {
    super.initState();

    // FIX: Add the tag here!
    houseController = Get.find<HomeController>(tag: 'show_search_map');

    _target = LatLng(widget.latitude, widget.longitude);
    _shareAddress = _cleanAddress(widget.address);

    final hasRamroAddress = _hasRamroAddress;
    final locationName = widget.locationName.trim();
    _addressTitle = hasRamroAddress
        ? _shareAddress
        : locationName.isNotEmpty
        ? locationName
        : _shareAddress;
    _addressSubtitle = hasRamroAddress
        ? '${widget.zone.trim()}, ${widget.sub.trim()}'
        : '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      houseController.setDestination(
        coordinates: _target,
        name: widget.address,
        title: _addressTitle,
        subtitle: _addressSubtitle,
      );
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    Get.delete<HomeController>(tag: 'show_search_map');
    super.dispose();
  }

  Positioned _mapTypeButton() {
    return Positioned(
      bottom: 250,
      right: 8,
      child: GestureDetector(
        onTap: () => _openMapSettings(),
        child: Container(
          padding: AppSpacing.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: AppRadius.circular(AppRadius.xxxl),
            border: Border.all(color: appTheme.gray50, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: AppTheme.light.colorScheme.shadow,
                offset: Offset(0, 0.5), // x=0px, y=0.5px
                blurRadius: 1.5, // 1.5px blur
                spreadRadius: 0, // 0px spread
              ),
            ],
          ),
          child: SvgPicture.asset(
            AppAssets.iconsSvgMapType,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
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
    if (chosen != null) setState(() => _selectedMapType = chosen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: AppBar(
        backgroundColor: appTheme.gray25,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            final polylines = houseController.polylines.toSet();

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _target, zoom: 20),
              polylines: polylines,
              markers: {
                ...houseController.locationMarker,
                ...houseController.houseMarkers,
              },
              onCameraMove: houseController.onCameraMove,
              onCameraIdle: houseController.onCameraIdle,
              mapType: _selectedMapType,
              compassEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(5, 21),
              onTap: _showNoAddressFound,
            );
          }),
          _mapTypeButton(),

          Obx(() {
            return Positioned.fill(
              child: BottomPanel(
                addressTitle: houseController.selectedHouseTitle.value,
                addressSubtitle: houseController.selectedHouseSubtitle.value,
                onNavigate: _drawRoute,
                onSave: () {},
                onShare: () => _shareRideDetails(context),
                onClose: _closeScreen,
              ),
            );
          }),
        ],
      ),
    );
  }

  bool get _hasRamroAddress {
    return widget.houseno.trim().isNotEmpty &&
        widget.street.trim().isNotEmpty &&
        widget.zone.trim().isNotEmpty &&
        widget.sub.trim().isNotEmpty;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    houseController.currentZoom.value = 20.0;
    final label = '${widget.sub} ${widget.houseno}'.trim();

    await houseController.prepareSearchMap(
      controller: controller,
      target: _target,
      highlightedLabel: label,
      forceLabelForTarget:
          label, // ADD THIS: Forces the label to have SubZone + HouseNum
    );
  }

  void _drawRoute() {
    houseController.drawRoute(houseController.myCurrentLocation.value, _target);
  }

  void _closeScreen() {
    houseController.clearDestination();
    Navigator.pop(context);
  }

  String _cleanAddress(String address) {
    final parts = address
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length > 2) {
      return parts.sublist(0, parts.length - 2).join(', ');
    }

    return parts.join(', ');
  }

  void _showNoAddressFound(LatLng _) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: const Text(
                      'No name found!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    'Missing zone, Missing sub zone',
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.black54,
                            ),
                            label: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              Get.toNamed(AppRoutes.addAddress);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Place'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareRideDetails(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    SharePlus.instance.share(
      ShareParams(
        text:
            "Hey, I'm sharing my location. Please search this address: $_shareAddress\n",
        subject: 'My Address',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

class MapTypeOption {
  final String name;
  final MapType mapType;

  const MapTypeOption(this.name, this.mapType);
}
