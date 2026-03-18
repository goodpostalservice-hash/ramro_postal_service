import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/widgets/get_polylines.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/controller/home_driver_map_controller.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/widgets/home_bottom_panel.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:location/location.dart';

class ShowSearchOnMapScreen extends StatefulWidget {
  final double latitude, longitude;
  final String address, street, zone, sub;
  String houseno;
  ShowSearchOnMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.houseno,
    required this.street,
    required this.zone,
    required this.sub,
  });

  @override
  State<ShowSearchOnMapScreen> createState() => _ShowSearchOnMapScreenState();
}

class _ShowSearchOnMapScreenState extends State<ShowSearchOnMapScreen> {
  // final List<Map<String, dynamic>> coordinates = AddressJSON.locations;

  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();
  final houseListController = Get.put(HomeDriverMapController());
  final bool _isMarkerVisible = true;
  LatLng? myDestinationLocation;
  LatLngBounds? bounds;
  Set<Marker> markers = {};
  final Set<Polyline> _polylines = <Polyline>{};
  final _helper = RoutePolylineHelper(apiKey: AppConstant.googleMapAPI);
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  double currentZoom = 19.0;
  LatLng? center;
  String? currentLocationName;
  String? _selectedValue;
  bool _isChecked = false;
  final List<String> _dropdownValues = ['Home', 'Work', 'Other'];
  final TextEditingController addressTypeController = TextEditingController();
  // map type
  final List<MapTypeOption> _mapTypes = [
    MapTypeOption('Normal', MapType.normal),
    MapTypeOption('Satellite', MapType.satellite),
    MapTypeOption('Terrain', MapType.terrain),
    MapTypeOption('Hybrid', MapType.hybrid),
  ];
  MapType _selectedMapType = MapType.normal;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    driverHouseListController.myDestinationName.value = widget.address;
    setMarkerValue();
  }

  // location workout
  // _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     userLatitude = position.latitude;
  //     userLongitude = position.longitude;
  //   });
  //   getCurrentLocationName(position.latitude, position.longitude);
  // }

  addRiderCustumIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/icons/tax_icon_small.png",
    );
  }

  _getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) async {
      if (mounted) {
        setState(() {
          userLatitude = location.latitude!;
          userLongitude = location.longitude!;
        });
      }
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: LatLng(userLatitude, userLongitude),
          icon: await addRiderCustumIcon(),
          infoWindow: const InfoWindow(title: "My Location"),
          // Customize the marker icon for pickup location if needed
        ),
      );
    });

    GoogleMapController? googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) async {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 19,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
            bearing: newLoc.heading ?? 0.0,
          ),
        ),
      );
      userLatitude = newLoc.latitude!;
      userLongitude = newLoc.longitude!;

      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: LatLng(newLoc.latitude!, newLoc.longitude!),
          icon: await addRiderCustumIcon(),
          // Customize the marker icon for pickup location if needed
        ),
      );
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    // this chunk of code will help to render the app when user
    // close and reopen the app from background
    _controller.complete(controller);
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        controller.setMapStyle("[]");
      }
      return null;
    });
  }

  final driverHouseListController = Get.put(HomeDriverMapController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.gray25,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showMapTypeSelector();
            },
            icon: const Icon(Icons.map, color: Colors.black),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 19,
            ),
            markers: markers,
            polylines: _polylines,
            mapType: _selectedMapType,
            compassEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(5, 19),
            onCameraMove: (position) {
              setState(() {
                center = position.target;
                currentZoom = position.zoom;
              });
            },
            onCameraIdle: () {
              if (currentZoom >= 19) {
                setMarkerValue();
              } else {
                markers.clear();

                setState(() {});
              }
            },
            onTap: ((position) {
              double lat = position.latitude;
              double lng = position.longitude;

              markers
                  .addLabelMarker(
                    LabelMarker(
                      visible: _isMarkerVisible,
                      label: "Missing address",
                      markerId: const MarkerId('houseno'),
                      textStyle: TextStyle(
                        color: _selectedMapType == MapType.normal
                            ? Colors.black45
                            : Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      position: LatLng(position.latitude, position.longitude),
                      backgroundColor: Colors.green,
                      onTap: () {
                        _showNoAddressFound(
                          'No name found!',
                          'Missing street name',
                          'Missing zone',
                          'Missing sub zone',
                          lat,
                          lng,
                        );
                      },
                    ),
                  )
                  .then((value) {
                    setState(() {});
                  });

              _showNoAddressFound(
                'No name found!',
                'Missing street name',
                'Missing zone',
                'Missing sub zone',
                lat,
                lng,
              );
            }),
          ),
          BottomPanel(
            addressTitle: splitCoordinateString(
              driverHouseListController.myDestinationName.value,
            ),
            addressSubtitle: 'addressSubtitle',
            onNavigate: () {
              _drawRoute(
                LatLng(
                  driverHouseListController.myCurrentLocation.value.latitude,
                  driverHouseListController.myCurrentLocation.value.longitude,
                ),
                LatLng(widget.latitude, widget.longitude),
              );
            },
            onSave: () {},
            onShare: () {},
            onClose: () {},
          ),
        ],
      ),
    );
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

    await _helper.fitToBounds(mapController, result.bounds, padding: 130);
  }

  void setMarkerValue() async {
    // var foundAdd = filterAddresses(center?.latitude ?? widget.latitude,
    //     center?.longitude ?? widget.longitude, 0.2);

    List<MapModel> foundAdd = await houseListController.getHouseList(
      center?.latitude ?? widget.latitude,
      center?.longitude ?? widget.longitude,
    );

    for (int i = 0; i < foundAdd.length; i++) {
      if (widget.houseno.toString() == foundAdd[i].houseNum) {
        markers
            .addLabelMarker(
              LabelMarker(
                visible: _isMarkerVisible,
                label: "${foundAdd[i].houseNum} ${foundAdd[i].subZone}",
                markerId: MarkerId(foundAdd[i].houseNum!),
                textStyle: TextStyle(
                  color: _selectedMapType == MapType.normal
                      ? Colors.black45
                      : Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                position: LatLng(
                  double.parse(foundAdd[i].latitude!),
                  double.parse(foundAdd[i].longitude!),
                ),
                backgroundColor: Colors.green,
                onTap: () async {
                  var initAddress = await getCurrentLocationName(
                    driverHouseListController.myCurrentLocation.value.latitude,
                    driverHouseListController.myCurrentLocation.value.longitude,
                  );
                  driverHouseListController.myDestinationName.value =
                      foundAdd[i].fullAddressDetail!;
                  // showAddressHomeSheet(
                  //   initAddress,
                  //   foundAdd[i].fullAddressDetail!,
                  //   LatLng(
                  //     double.parse(foundAdd[i].latitude!),
                  //     double.parse(foundAdd[i].longitude!),
                  //   ),
                  //   false,
                  //   true,
                  // );
                },
              ),
            )
            .then((value) {
              setState(() {});
            });
      } else {
        markers
            .addLabelMarker(
              LabelMarker(
                visible: _isMarkerVisible,
                onTap: () async {
                  var initAddress = await getCurrentLocationName(
                    driverHouseListController.myCurrentLocation.value.latitude,
                    driverHouseListController.myCurrentLocation.value.longitude,
                  );
                  driverHouseListController.myDestinationName.value =
                      foundAdd[i].fullAddressDetail!;

                  setState(() {
                    widget.houseno = foundAdd[i].houseNum!;
                  });
                },
                label: "${foundAdd[i].houseNum} ${foundAdd[i].subZone}",
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
                markerId: MarkerId(foundAdd[i].houseNum ?? "houseno"),
                position: LatLng(
                  double.parse(foundAdd[i].latitude!),
                  double.parse(foundAdd[i].longitude!),
                ),
                backgroundColor: Colors.transparent,
              ),
            )
            .then((value) {
              setState(() {});
            });
        markers.add(
          Marker(
            markerId: const MarkerId('marker'),
            position: LatLng(widget.latitude, widget.longitude),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    }
  }

  Future<BitmapDescriptor> _destinationIcon() {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      ImageConstant.currentLocationPng,
    );
  }

  // address save option function
  showAddressSaveOption(LatLng latLng, String destinationAddress) {
    final driverHouseListController = Get.find<HomeDriverMapController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10.0),
          contentPadding: const EdgeInsets.all(15.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: const Text(
                          '- Select To Continue -',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Select Address Type'),
                            value: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },
                            items: _dropdownValues.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.only(left: 2.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: addressTypeController,
                          decoration: const InputDecoration(
                            hintText: 'eg. Address name',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        padding: const EdgeInsets.only(left: 2.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: CheckboxListTile(
                          title: const Text(
                            'Set As Default Address',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]!,
                            ),
                            child: const SizedBox(
                              height: 50.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              await driverHouseListController.saveQR(
                                latLng.longitude.toString(),
                                latLng.latitude.toString(),
                                destinationAddress,
                                addressTypeController.text == ""
                                    ? _selectedValue
                                    : addressTypeController.text,
                                _isChecked,
                              );

                              Get.put(SavedAddressController());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: SizedBox(
                              height: 50.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  driverHouseListController.isLoading.value ==
                                          true
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String splitCoordinateString(String address) {
    List<String> addressParts = address.split(
      ',',
    ); // Split the address by commas
    // Remove the last two words (latitude and longitude)
    List<String> remainingParts = addressParts.sublist(
      0,
      addressParts.length - 2,
    );
    String result = remainingParts.join(',');
    // Join the remaining parts with commas
    return result;
  }

  void _showNoAddressFound(
    String address,
    String street,
    String zone,
    String sub,
    double latitude,
    double longitude,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50.0,
                      height: 3.0,
                      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Text(
                    "$zone, $sub",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.grey[200]!,
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
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // AddPlaceScreen.lat = latitude;
                                // AddPlaceScreen.lng = longitude;

                                Get.toNamed('/addPlace');
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

  void _showMapTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 230.0,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mapTypes.length,
            itemBuilder: (BuildContext context, int index) {
              final mapTypeOption = _mapTypes[index];
              return ListTile(
                title: Text(mapTypeOption.name),
                onTap: () {
                  setState(() {
                    _selectedMapType = mapTypeOption.mapType;
                  });
                  // setMarkerValue();
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _shareRideDetails(BuildContext context, String address) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    var rideAdd = splitCoordinateString(address);
    Share.share(
      "Hey, I'm sharing my  location. Please search this address:$rideAdd \n https://play.google.com/store/apps/details?id=com.gps.ramro_postal_service ",
      subject: 'My Address',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}

class MapTypeOption {
  final String name;
  final MapType mapType;

  MapTypeOption(this.name, this.mapType);
}
