import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:location/location.dart';
import 'package:ramro_postal_service/modal/map_model.dart';
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/controller/home_map_controller.dart';
import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
import 'package:ramro_postal_service/screen/search/presentation/view/google_search_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_constant.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../resource/color.dart';
import 'package:http/http.dart' as http;

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});
  static LatLng? currentLocationAtStart;
  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  LatLngBounds? bounds;
  final Completer<GoogleMapController> _controller = Completer();

  final double _zoomThreshold = 18.5;

  // Set<Polyline> _polylines = {};

  String googleAPIKey = AppConstant.MAP_KEY;
  late GoogleMapController? googleMapController;
  // map type
  final List<MapTypeOption> _mapTypes = [
    MapTypeOption('Normal', MapType.normal),
    MapTypeOption('Satellite', MapType.satellite),
    MapTypeOption('Terrain', MapType.terrain),
    MapTypeOption('Hybrid', MapType.hybrid),
  ];

  MapType _selectedMapType = MapType.normal;
  String? _selectedValue;
  bool isChecked = false;
  String? _knownAddselectedValue;
  bool isknownAddChecked = false;
  final List<String> _dropdownValues = ['Home', 'Work', 'Other'];
  final TextEditingController addressTypeController = TextEditingController();
  final TextEditingController addressKnownTypeController =
      TextEditingController();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final houseListController = Get.put(HomeMapController());

  @override
  void dispose() {
    googleMapController?.dispose();
    houseListController.markers.clear();

    super.dispose();
  }

  void _getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) async {
      houseListController.myCurrentLocation.value = location;
    });

    googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) async {
      houseListController.myCurrentLocation.value = newLoc;

      houseListController.markers.add(
        Marker(
          markerId: const MarkerId('homemarkers'),
          position: LatLng(
            houseListController.myCurrentLocation.value.latitude!,
            houseListController.myCurrentLocation.value.longitude!,
          ),
          icon: await addUserCustumIcon(),
          infoWindow: const InfoWindow(title: "My Location"),
          // Customize the marker icon for pickup location if needed
        ),
      );
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // get current pin
    houseListController.markers.clear();
    _getCurrentLocation();
    // showBanner();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        minAppVersion: "1.0.3",
        // dialogStyle: UpgradeDialogStyle.material,
        durationUntilAlertAgain: const Duration(hours: 2),
      ),
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            child: Stack(
              children: <Widget>[
                CustomGoogleMap(),

                // check if driver is logged in
                showTopMenuWidget(),

                Positioned(
                  bottom: 180,
                  right: 8,
                  child: Visibility(
                    visible:
                        houseListController.isMyLocationButtonVisible.value,
                    child: GestureDetector(
                      onTap: () {
                        showMyLocation();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_searching,
                          size: 24.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                // Positioned.fill(
                //     child:
                //         Align(alignment: Alignment.center, child: _getMarker()))
                // set banner position
                // Positioned(
                //   bottom: 10,
                //   right: 0,
                //   left: 0,
                //   child: carousel(),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    // this chunk of code will help to render the app when user
    // close and reopen the app from background
    _controller.complete(controller);
    googleMapController = controller;

    // SystemChannels.lifecycle.setMessageHandler((msg) async {
    //   if (msg == AppLifecycleState.resumed.toString()) {
    //     controller.setMapStyle("[]");
    //   }
    //   return null;
    // });
  }

  Widget CustomGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          houseListController.myCurrentLocation.value.latitude ??
              HomeMapScreen.currentLocationAtStart!.latitude,
          houseListController.myCurrentLocation.value.longitude ??
              HomeMapScreen.currentLocationAtStart!.longitude,
        ),
        zoom: 17,
      ),
      markers: houseListController.markers,
      mapType: _selectedMapType,
      mapToolbarEnabled: false,
      onLongPress: (latLng) async {
        houseListController.markers.add(
          Marker(
            markerId: const MarkerId('ride_marker'),
            position: latLng,
            draggable: true,
          ),
        );
        Position position = await Geolocator.getCurrentPosition();
        var myAdd = await getCurrentLocationName(
          latLng.latitude,
          latLng.longitude,
        );
        var initAddress = await getCurrentLocationName(
          position.latitude,
          position.longitude,
        );
        showAddressHomeSheet(myAdd, initAddress, latLng);
      },
      // myLocationButtonEnabled: false,
      // myLocationEnabled: true,
      zoomControlsEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(5, 19),
      onCameraMove: (position) {
        houseListController.center.value = position.target;
        houseListController.currentZoom.value = position.zoom;
      },
      onCameraIdle: () {
        if (houseListController.currentZoom.value >= 19) {
          setMarkerValue();
        } else {
          setState(() {
            houseListController.markers.clear();
          });
        }
      },

      trafficEnabled: true,
    );
  }

  // sliders
  Widget carousel() {
    return Container(
      child: bannerList.isNotEmpty
          ? CarouselSlider(
              options: CarouselOptions(
                height: 100.0,
                viewportFraction: 0.7,
                initialPage: 0,
                onPageChanged: (index, _) {
                  setState(() {
                    // _current = index;
                  });
                },
                autoPlay: true,
              ),
              items: bannerList.map<Widget>((imageURL) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        _launchURL(imageURL['url'].toString());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: 100.0,
                            imageUrl:
                                imageURL['image_url'] ??
                                "https://lazesoftware.com/img/en/tool/dummyimg/default_480x320.png",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/banners/ic_app_card_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/banners/ic_app_card_placeholder.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          : Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              height: 140.0,
              width: double.infinity,
              child: Image.asset(
                "assets/banners/ic_app_card_placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  // open url
  void _launchURL(String imageUrl) async {
    if (!await launch(imageUrl)) throw 'Could not launch $imageUrl';
  }

  // custom icon for driver
  addRiderCustumIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/icons/tax_icon_small.png",
    );
  }

  addUserCustumIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/icons/user_location_icon.png",
    );
  }

  // show banner
  List bannerList = [];
  showBanner() async {
    var dio = Dio();

    final response = await dio
        .get(
          ApiConstant.slider,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': "Bearer ${AppConstant.bearerToken.toString()}",
            },
          ),
        )
        .catchError((error, stackTrace) {
          print("Error: ${error['data']['message']}");
        });

    final responseData = response.data;
    if (response.statusCode == 200) {
      if (mounted) {
        for (var i = 0; i < responseData.length; i++) {
          bannerList.add(responseData[i]);
        }
        setState(() {});
      }
    } else {
      print("Error: ${responseData['message']}");
    }
  }

  void setMarkerValue() async {
    List<MapModel> foundAdd = await houseListController.getHouseList(
      houseListController.center.value.latitude,
      houseListController.center.value.longitude,
    );

    if (foundAdd.isNotEmpty) {
      for (int i = 0; i < foundAdd.length; i++) {
        await houseListController.markers
            .addLabelMarker(
              LabelMarker(
                visible: true,
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition();
                  var initAddress = await getCurrentLocationName(
                    position.latitude,
                    position.longitude,
                  );
                  _showAddressDetail(
                    foundAdd[i].fullAddressDetail!,
                    initAddress,
                    foundAdd[i].street!,
                    foundAdd[i].zone!,
                    foundAdd[i].subZone!,
                    foundAdd[i].latitude!,
                    foundAdd[i].longitude!,
                  );
                },
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

  // without house numbers bottom sheet
  showAddressHomeSheet(String address, String initialAddress, LatLng latLng) {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext cxt) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalState) => Container(
            color: Colors.white,
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            height: height * 0.25,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 50.0,
                          height: 3.0,
                          margin: const EdgeInsets.only(
                            bottom: 10.0,
                            top: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          houseListController.markers.remove(
                            Marker(
                              markerId: const MarkerId('ride_marker'),
                              position: latLng,
                              draggable: true,
                            ),
                          );
                          Navigator.pop(cxt);
                        },
                        icon: Icon(Icons.close, color: Colors.grey[400]!),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                      child: Text(
                        initialAddress,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                    child: Text(
                      splitCoordinateString(address),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AppConstant.loggedInUserType == 'merchant'
                              ? Container(
                                  height: height * 0.05,
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    icon: const Icon(Icons.print),
                                    label: const Text('Print Qr code'),
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/delivery.png',
                                          height: 30,
                                        ),
                                        const Text(
                                          'Request Pickup',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.all(10.0),
                                      contentPadding: const EdgeInsets.all(
                                        15.0,
                                      ),
                                      content: StatefulBuilder(
                                        builder:
                                            (
                                              BuildContext context,
                                              StateSetter setState,
                                            ) {
                                              return SizedBox(
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5.0,
                                                          ),
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 10.0,
                                                          ),
                                                      child: const Text(
                                                        '- Select To Continue -',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 12.0,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[300]!,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.0,
                                                            ),
                                                      ),
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                          hint: const Text(
                                                            'Select Address Type',
                                                          ),
                                                          value: _selectedValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _selectedValue =
                                                                  value;
                                                            });
                                                          },
                                                          items: _dropdownValues
                                                              .map((
                                                                String value,
                                                              ) {
                                                                return DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  value: value,
                                                                  child: Text(
                                                                    value,
                                                                  ),
                                                                );
                                                              })
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            top: 20.0,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 2.0,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[300]!,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.0,
                                                            ),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            addressTypeController,
                                                        decoration: const InputDecoration(
                                                          hintText:
                                                              'eg. Address name',
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 20.0,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 2.0,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[300]!,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.0,
                                                            ),
                                                      ),
                                                      child: CheckboxListTile(
                                                        title: const Text(
                                                          'Set As Default Address',
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                        value: isChecked,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isChecked = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300]!,
                                                          ),
                                                          child: const SizedBox(
                                                            height: 50.0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            await houseListController.saveQR(
                                                              latLng.longitude
                                                                  .toString(),
                                                              latLng.latitude
                                                                  .toString(),
                                                              address,
                                                              addressTypeController
                                                                          .text ==
                                                                      ""
                                                                  ? _selectedValue
                                                                  : addressTypeController
                                                                        .text,
                                                              isChecked,
                                                            );

                                                            Get.put(
                                                              SavedAddressController(),
                                                            );
                                                          },
                                                          style:
                                                              ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                              ),
                                                          child: const SizedBox(
                                                            height: 50.0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                Text(
                                                                  'Save',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      ),
                                    );
                                  },
                                );
                                // await driverHouseListController.saveQR(
                                //     latLng.latitude.toString(),
                                //     latLng.longitude.toString(),
                                //     address,
                                //     '');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.save),
                              label: const Text('Save Address'),
                            ),
                          ),
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                Get.toNamed('/addMissingAddressOnMap');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                              label: const Text('Add Missing Address'),
                            ),
                          ),
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                _shareRideDetails(context, address);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // with house numbers bottom sheet
  void _showAddressDetail(
    String address,
    String initAddress,
    String street,
    String zone,
    String sub,
    String latitude,
    String longitude,
  ) {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext cxt) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalState) => Container(
            color: Colors.white,
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            height: height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
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
                    IconButton(
                      onPressed: () {
                        Navigator.pop(cxt);
                      },
                      icon: Icon(Icons.close, color: Colors.grey[400]!),
                    ),
                  ],
                ),
                Text(
                  initAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 15.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                  child: Text(
                    splitCoordinateString(address),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 15.0,
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.print),
                            label: const Text('Print QR Code'),
                          ),
                        ),
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(10.0),
                                    contentPadding: const EdgeInsets.all(15.0),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return SizedBox(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  5.0,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  bottom: 10.0,
                                                ),
                                                child: const Text(
                                                  '- Select To Continue -',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 12.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    hint: const Text(
                                                      'Select Address Type',
                                                    ),
                                                    value:
                                                        _knownAddselectedValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _knownAddselectedValue =
                                                            value;
                                                      });
                                                    },
                                                    items: _dropdownValues.map((
                                                      String value,
                                                    ) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 2.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                      addressKnownTypeController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            'eg. Address name',
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                            ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  bottom: 20.0,
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 2.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                child: CheckboxListTile(
                                                  title: const Text(
                                                    'Set As Default Address',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  value: isknownAddChecked,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isknownAddChecked =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[300]!,
                                                        ),
                                                    child: const SizedBox(
                                                      height: 50.0,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await houseListController.saveQR(
                                                        longitude,
                                                        latitude,
                                                        address,
                                                        addressKnownTypeController
                                                                    .text ==
                                                                ""
                                                            ? _knownAddselectedValue
                                                            : addressKnownTypeController
                                                                  .text,
                                                        isknownAddChecked,
                                                      );
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.primary,
                                                        ),
                                                    child: const SizedBox(
                                                      height: 50.0,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.save),
                            label: const Text('Save Address'),
                          ),
                        ),
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // _shareRideDetails(context, address);
                              await _launchMapURL(
                                double.parse(latitude),
                                double.parse(longitude),
                              );
                              // Add your logic for share button here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchMapURL(double lat, double lng) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=${AppConstant.MAP_KEY}&destination=$lat,$lng";

    if (await canLaunchUrl(Uri(path: googleMapsUrl))) {
      await launchUrl(Uri(path: googleMapsUrl));
    } else {
      throw "Couldn't launch URL";
    }
  }

  // share ride request
  void _shareRideDetails(BuildContext context, String address) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    var rideAdd = splitCoordinateString(address);
    Share.share(
      "Hey, I'm sharing my  location. Please search this address:$rideAdd \n https://play.google.com/store/apps/details?id=com.gps.ramro_postal_service",
      subject: 'Share  Address',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void openPackageDelivery(
    double latitude,
    double longitude,
    String destAddress,
    String pickupAddress,
  ) {
    final formKey = GlobalKey<FormState>();
    final pickUpLocation = TextEditingController(text: pickupAddress);
    final destinationLocation = TextEditingController(text: destAddress);
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
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Delivery Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Pickup Address:',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                height: 50.0,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 7.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter pick up location';
                                    }
                                    return null;
                                  },
                                  controller: pickUpLocation,
                                  onTap: () {
                                    Get.to(
                                      () => const GoogleSearchScreen(
                                        pickLocation: 1,
                                      ),
                                    );
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  // controller:
                                  //     controller.pickUpLocationController,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    hintText: 'Pick up location',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                'Drop Address:',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                height: 50.0,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 7.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter drop location';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    Get.to(
                                      () => const GoogleSearchScreen(
                                        pickLocation: 0,
                                      ),
                                    );
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  controller: destinationLocation,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    hintText: 'Drop location',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 7.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter package details';
                                    }
                                    return null;
                                  },

                                  // controller: controller.dropLocationController,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    hintText: 'Package Details',
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.bike_scooter),
                              label: const Text('Send Delivery Request'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
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

  // share ride request
  // void _shareRideDetails(BuildContext context, double lat, double long) {
  //   final RenderBox box = context.findRenderObject() as RenderBox;
  //   Share.share(
  //       "Hey, I\'m sharing my live location. Please click the link below to have a live feed.\nhttps://ramropostalservice.com/ride-location?id=1394&lat=$lat&lng=$long",
  //       subject: 'Ride Details',
  //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  // }

  Future<String> getCurrentLocationName(
    double latitude,
    double longitude,
  ) async {
    final uri =
        "https://easytaxinepal.com/nominatim/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1";
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{},
    );
    final responseData = await json.decode(response.body);
    return responseData['display_name'].toString();
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
    String result = remainingParts.join(
      ',',
    ); // Join the remaining parts with commas
    return result;
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

  void showMyLocation() async {
    googleMapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          houseListController.myCurrentLocation.value.latitude!,
          houseListController.myCurrentLocation.value.longitude!,
        ),
        19.0,
      ),
    );
    // try {
    //   Position myLoation = await _determinePosition();
    //   CameraUpdate.newLatLngZoom(
    //       LatLng(myLoation.latitude, myLoation.longitude), 19.0);
    // } catch (e) {
    //   print(e.toString());
    // }
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

  Widget showTopMenuWidget() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width - 74.0,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoogleSearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/icons/ic_shop_destination.png",
                                height: 18.0,
                                width: 18.0,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Search Destination',
                                style: TextStyle(color: AppColors.lightGrey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              _showMapTypeSelector();
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.map_sharp,
                size: 24.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // this section is for a driver
  void _showOnlineNotification() async {
    const channelId = 'online_channel';
    const channelName = 'Driver Online Status';
    const channelDescription = 'Shows driver online status notifications';

    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(channelId, channelName,
    //         importance: Importance.high,
    //         priority: Priority.high,
    //         playSound: true,
    //         icon: "drawable/online.png");

    // const IOSNotificationDetails iOSPlatformChannelSpecifics =
    //     IOSNotificationDetails();

    // const NotificationDetails platformChannelSpecifics = NotificationDetails(
    //   android: androidPlatformChannelSpecifics,
    //   iOS: iOSPlatformChannelSpecifics,
    // );

    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   'Driver Online',
    //   'You are now online!',
    //   platformChannelSpecifics,
    // );
  }

  void _removeNotification() async {
    // await flutterLocalNotificationsPlugin.cancel(0);
  }
}

class MapTypeOption {
  final String name;
  final MapType mapType;

  MapTypeOption(this.name, this.mapType);
}
