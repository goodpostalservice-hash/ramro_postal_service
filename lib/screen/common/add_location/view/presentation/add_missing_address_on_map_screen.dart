import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/common/add_location/controller/add_place_controller.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/driver_home_map_screen.dart';
import '../../../../../resource/color.dart';
import '../../../../home_map/home_map_screen/presentation/widgets/get_location_name.dart';
import 'add_place_screen.dart';

class AddMissingAddressOnMapScreen extends StatefulWidget {
  const AddMissingAddressOnMapScreen({super.key});

  @override
  State<AddMissingAddressOnMapScreen> createState() =>
      _AddMissingAddressOnMapScreenState();
}

class _AddMissingAddressOnMapScreenState
    extends State<AddMissingAddressOnMapScreen> {
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();

  GoogleMapController? mapController;
  final addressController = Get.put(AddPlaceController());
  LatLng center = const LatLng(27.712405, 85.353815);
  late Position _currentPosition;
  late double _latitude = DriverHomeMapScreen.currentLocationAtStart!.latitude,
      _longitude = DriverHomeMapScreen.currentLocationAtStart!.longitude;
  double zoomValue = 17;
  late CameraPosition _kGooglePlex;
  // final List<MapTypeOption> _mapTypes = [
  //   MapTypeOption('Normal', MapType.normal),
  //   MapTypeOption('Satellite', MapType.satellite),
  //   MapTypeOption('Terrain', MapType.terrain),
  //   MapTypeOption('Hybrid', MapType.hybrid),
  // ];
  Set<Marker> markers = {};

  final MapType _selectedMapType = MapType.satellite;
  String? dropLocation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late double width, height;
  late bool showMaker;
  late bool initButton = true;

  @override
  void initState() {
    super.initState();

    zoomValue = 16;

    _kGooglePlex = CameraPosition(
      target: LatLng(_latitude, _longitude),
      zoom: zoomValue,
    );

    _pickupController.text = "";

    // get current pin
    _getCurrentLocation();

    showMaker = false;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            CustomGoogleMap(),

            Positioned(
              top: 50.0,
              left: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90.0),
                    color: Colors.white,
                  ),
                  width: 40.0,
                  height: 40.0,
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),

            Positioned(
              top: height / 2 - 125,
              left: width / 2 - 20.0,
              child: Image.asset(
                "assets/icons/ic_marker_rides_destination.png",
                height: 55.0,
              ),
            ),

            // adjust my location position
            Positioned(
              bottom: 16,
              right: 16,
              child: Visibility(
                visible: true,
                child: GestureDetector(
                  onTap: () {
                    showMyLocation();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_searching,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          height: 145.0,
          child: Column(
            children: <Widget>[
              // confirm destination
              Container(
                margin: const EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                  top: 5.0,
                  bottom: 14.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: AppColors.borderColor, width: 1.0),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/icons/ic_shop_destination.png",
                      height: 28.0,
                      width: 28.0,
                    ),
                    SizedBox(
                      width: width - 92.0,
                      child: TextField(
                        controller: _dropController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14.0),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            bottom: 11,
                            top: 11,
                            right: 15,
                          ),
                          labelText: "Generate Location (QR)",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // confirm
              button(),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        _moveToScreen2(context);
        return false;
      },
    );
  }

  void _moveToScreen2(BuildContext context) =>
      Navigator.pushReplacementNamed(context, "/dashboard");

  Widget CustomGoogleMap() {
    return GoogleMap(
      mapType: MapType.satellite,
      initialCameraPosition: _kGooglePlex,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(5, 19),
      onMapCreated: (GoogleMapController controller) {
        // this chunk of code will help to render the app when user
        // close and reopen the app from background
        SystemChannels.lifecycle.setMessageHandler((msg) async {
          if (msg == AppLifecycleState.resumed.toString()) {
            controller.setMapStyle("[]");
          }
          return null;
        });

        mapController = controller;
      },
      myLocationEnabled: true,
      markers: markers,
      onCameraMove: ((position) {
        setState(() {
          center = position.target;
          zoomValue = position.zoom;
        });
      }),
      onCameraIdle: (() async {
        getCurrentLocationName(center.latitude, center.longitude).toString();
        if (zoomValue >= 19) {
          setMarkerValue();
        } else {
          markers.clear();
        }
      }),
    );
  }

  void setMarkerValue() async {
    List<MapModel> foundAdd = await addressController.getHouseList(
      center.latitude,
      center.longitude,
    );
    print("##############");
    print(foundAdd.length.toString());
    if (foundAdd.isNotEmpty) {
      for (int i = 0; i < foundAdd.length; i++) {
        markers
            .addLabelMarker(
              LabelMarker(
                visible: true,
                onTap: () {},
                label:
                    "${foundAdd[i].houseNum.toString()} ${foundAdd[i].subZone.toString()}",
                textStyle: TextStyle(
                  color:
                      _selectedMapType == MapType.normal ||
                          _selectedMapType == MapType.terrain
                      ? Colors.black45
                      : Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  inherit: true,
                  shadows: [
                    Shadow(
                      // bottomLeft
                      offset: const Offset(-1.5, -1.5),
                      color:
                          _selectedMapType == MapType.normal ||
                              _selectedMapType == MapType.terrain
                          ? Colors.transparent
                          : Colors.black87,
                    ),
                    Shadow(
                      // bottomRight
                      offset: const Offset(1.5, -1.5),
                      color:
                          _selectedMapType == MapType.normal ||
                              _selectedMapType == MapType.terrain
                          ? Colors.transparent
                          : Colors.black87,
                    ),
                    Shadow(
                      // topRight
                      offset: const Offset(1.5, 1.5),
                      color:
                          _selectedMapType == MapType.normal ||
                              _selectedMapType == MapType.terrain
                          ? Colors.transparent
                          : Colors.black87,
                    ),
                    Shadow(
                      // topLeft
                      offset: const Offset(-1.5, 1.5),
                      color:
                          _selectedMapType == MapType.normal ||
                              _selectedMapType == MapType.terrain
                          ? Colors.transparent
                          : Colors.black87,
                    ),
                  ],
                ),
                markerId: MarkerId(
                  "${foundAdd[i].houseNum.toString()} ${foundAdd[i].subZone.toString()}",
                ),
                position: LatLng(
                  double.parse(foundAdd[i].latitude!),
                  double.parse(foundAdd[i].longitude!),
                ),
                backgroundColor: Colors.transparent,
              ),
            )
            .then((value) {
              if (mounted) {
                setState(() {});
              }
            });
      }
    } else {
      print("no address found within 200 m");
    }
  }

  Widget button() {
    return ElevatedButton(
      onPressed: () {
        AddPlaceScreen.lat = center.latitude;
        AddPlaceScreen.lng = center.longitude;
        Get.toNamed('/addPlace');
      },
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          color: initButton ? AppColors.primary : AppColors.disabledPrimaryBtn,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Proceed Location'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  // location workout
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _kGooglePlex = CameraPosition(
        target: LatLng(_latitude, _longitude),
        zoom: zoomValue,
      );
    });

    getCurrentLocationName(_latitude, _longitude);
  }
}
