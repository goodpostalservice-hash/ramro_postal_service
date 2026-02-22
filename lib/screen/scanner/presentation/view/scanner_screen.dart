// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:ramro_postal_service/core/constants/app_constant.dart';
// import 'package:ramro_postal_service/core/error/toast.dart';
// import 'package:ramro_postal_service/resource/color.dart';
// import 'package:ramro_postal_service/resource/data.dart';
// import 'package:ramro_postal_service/screen/main/map/screen/map_mode.dart';
// import 'package:ramro_postal_service/screen/profile/controller/profile_controller.dart';
// import 'package:ramro_postal_service/screen/saved_address/controller/saved_address_controller.dart';
// import 'package:ramro_postal_service/screen/search/controller/search_controller.dart';
// import 'package:ramro_postal_service/screen/search/presentation/view/google_search_screen.dart';
// import 'package:ramro_postal_service/screen/search/presentation/view/show_search_on_map_screen.dart';
// import 'package:ramro_postal_service/utility/widgets.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:scan/scan.dart';

// class ScannerScreen extends StatefulWidget {
//   String? whatToScan;
//   ScannerScreen({super.key, this.whatToScan});

//   @override
//   State<ScannerScreen> createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   String? _qrInfo = 'Scan a QR/Bar code';
//   bool _camState = false;
//   bool apiHold = false;
//   String qrMenu = "Scan";
//   final ImagePicker _picker = ImagePicker();
//   bool apiFoodStatus = false;
//   String responseMessage = '';
//   final savedAddressController = Get.put(SavedAddressController());
//   final usrProfileController = Get.put(ProfileController());
//   ScanController scanController = ScanController();
//   final GlobalKey _qrKey = GlobalKey();
//   _scanCode() {
//     setState(() {
//       _camState = true;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     ListData.qrMenu[0]['status'] = 1;
//     _scanCode();
//     print("Cam state:$_camState");
//   }

//   _qrCallback(String? code) {
//     setState(() {
//       _camState = false;
//       _qrInfo = code;
//       responseMessage = code.toString();
//     });
//     if (apiHold == false) {
//       // getRollBack();
//       log('scan document: $code');
//     }
//   }

//   String _imagePath = '';
//   Future<void> _getImage() async {
//     final XFile? pickedImage =
//         await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _imagePath = pickedImage.path;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     ListData.qrMenu[1]['status'] = 0;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//       ),
//       body: _camState
//           ? Column(
//               children: [
//                 const SizedBox(
//                   height: 80,
//                 ),
//                 menu(),
//                 qrMenu == "Scan"
//                     ? Center(
//                         child: Column(
//                           children: [
//                             IconButton(
//                                 onPressed: () async {
//                                   await _getImage();
//                                   String? result = await Scan.parse(_imagePath);
//                                   if (result != null) {
//                                     _qrCallback(result);
//                                   } else {}
//                                 },
//                                 icon: const Icon(Icons.image)),
//                             SizedBox(
//                               height: 320,
//                               width: 320,
//                               child: QRBarScannerCamera(
//                                 onError: (context, error) => Text(
//                                   error.toString(),
//                                   style: const TextStyle(color: Colors.red),
//                                 ),
//                                 qrCodeCallback: (code) {
//                                   _qrCallback(code);
//                                 },
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20.0,
//                             ),
//                             const Text(
//                               "Scan QR Code",
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.w700),
//                             ),
//                           ],
//                         ),
//                       )
//                     : usrProfileController.resultList.subject.value?.address !=
//                             null
//                         ? Center(
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 320,
//                                   width: 320,
//                                   child: QrImageView(
//                                     data: usrProfileController
//                                         .resultList.subject.value!.address!,
//                                     version: QrVersions.auto,
//                                     size: 160,
//                                     gapless: false,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20.0,
//                                 ),
//                                 InkWell(
//                                   onTap: () async {
//                                     await _shareQRImage(usrProfileController
//                                         .resultList.subject.value!.address!);
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(15.0),
//                                     decoration: BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius:
//                                             BorderRadius.circular(12.0)),
//                                     child: const Text(
//                                       "Share QR Code",
//                                       style: TextStyle(
//                                           fontSize: 24,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : savedAddressController.myDefaultQR == null
//                             ? Center(
//                                 heightFactor: 3,
//                                 child: InkWell(
//                                     onTap: () {
//                                       Get.to(() => const GoogleSearchScreen(
//                                             pickLocation: 3,
//                                           ));
//                                       // Get.to(() => const MapScreen());
//                                     },
//                                     child: Column(
//                                       children: [
//                                         Image.asset(
//                                             "assets/icons/ic_shop_destination.png"),
//                                         const SizedBox(height: 15.0),
//                                         Container(
//                                           padding: const EdgeInsets.all(8.0),
//                                           decoration: BoxDecoration(
//                                               color: Colors.blue,
//                                               borderRadius:
//                                                   BorderRadius.circular(8.0)),
//                                           child: const Text(
//                                             "Choose your Address",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ],
//                                     )))
//                             : Center(
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 320,
//                                       width: 320,
//                                       child: PrettyQrView.data(
//                                         data: savedAddressController
//                                             .myDefaultQR!.addressMap
//                                             .toString(),
//                                         decoration: const PrettyQrDecoration(
//                                           image: PrettyQrDecorationImage(
//                                             image: AssetImage(
//                                                 'assets/icons/logo.png'),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 20.0,
//                                     ),
//                                     InkWell(
//                                       onTap: () async {
//                                         await _shareQRImage(
//                                             savedAddressController
//                                                 .myDefaultQR!.addressMap
//                                                 .toString());
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.all(15.0),
//                                         decoration: BoxDecoration(
//                                             color: AppColors.primary,
//                                             borderRadius:
//                                                 BorderRadius.circular(12.0)),
//                                         child: const Text(
//                                           "Share QR Code",
//                                           style: TextStyle(
//                                               fontSize: 24,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//               ],
//             )
//           : Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset('assets/icons/viewmapscan.png', height: 120.0),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30.0),
//                     child: Text(
//                         responseMessage == ''
//                             ? 'Scanning took long time. Please try again later'
//                             : responseMessage,
//                         style: const TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.blue,
//                             fontWeight: FontWeight.normal),
//                         textAlign: TextAlign.center),
//                   ),
//                   if (responseMessage == '')
//                     Container(
//                       margin: const EdgeInsets.only(top: 20.0),
//                       width: 200,
//                       height: 50.0,
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromRGBO(255, 44, 85, 2)),
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Searching ...',
//                               style: TextStyle(
//                                   fontSize: 17.0,
//                                   fontWeight: FontWeight.bold))),
//                     ),
//                   if (responseMessage != '')
//                     Container(
//                       margin: const EdgeInsets.only(top: 70.0),
//                       width: 240,
//                       height: 50.0,
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary),
//                           onPressed: () async {
//                             final searchController =
//                                 Get.put(SearchMapController());
//                             final searchResult = await searchController
//                                 .getSearchAddresses(responseMessage);

//                             if (searchResult != null) {
//                               Get.to(() => ShowSearchOnMapScreen(
//                                   latitude:
//                                       double.parse(searchResult[0]['latitude']),
//                                   longitude: double.parse(
//                                       searchResult[0]['longitude']),
//                                   address: searchResult[0]
//                                       ['full_address_detail'],
//                                   houseno: searchResult[0]['house_num'],
//                                   street: searchResult[0]['street'],
//                                   zone: searchResult[0]['zone'],
//                                   sub: searchResult[0]['sub_zone']));
//                             } else {
//                               LatLng? cods =
//                                   await getPlaceCoordinates(responseMessage);
//                               cods != null
//                                   ? Get.to(() => ShowSearchOnMapScreen(
//                                       latitude: cods.latitude,
//                                       longitude: cods.longitude,
//                                       address: responseMessage,
//                                       houseno: '',
//                                       street: '',
//                                       zone: "",
//                                       sub: ''))
//                                   : showErrorMessage(
//                                       "could not open this address in map");
//                             }

//                             // if (myList.length == 5 &&
//                             //     responseMessage.contains(".")) {
//                             //   Get.to(() => ShowSearchOnMapScreen(
//                             //       latitude: double.parse(myList[3]),
//                             //       longitude: double.parse(myList[4]),
//                             //       address: add,
//                             //       houseno: firstAdd[0],
//                             //       street: firstAdd[1],
//                             //       zone: "",
//                             //       sub: firstAdd[2]));
//                             // } else {
//                             //   LatLng? cods =
//                             //       await getPlaceCoordinates(responseMessage);
//                             //   cods != null
//                             //       ? Get.to(() => ShowSearchOnMapScreen(
//                             //           latitude: cods.latitude,
//                             //           longitude: cods.longitude,
//                             //           address: add,
//                             //           houseno: '',
//                             //           street: '',
//                             //           zone: "",
//                             //           sub: ''))
//                             //       : showErrorMessage(
//                             //           "could not open this address in map");
//                             // }
//                           },
//                           child: const Text('Show in map',
//                               style: TextStyle(
//                                   fontSize: 15.0,
//                                   fontWeight: FontWeight.bold))),
//                     ),
//                 ],
//               ),
//               // child: Text(_qrInfo!),
//             ),
//     );
//   }

//   String splitCoordinateString(String address) {
//     List<String> addressParts =
//         address.split(','); // Split the address by commas
//     // Remove the last two words (latitude and longitude)
//     List<String> remainingParts =
//         addressParts.sublist(0, addressParts.length - 2);
//     String result =
//         remainingParts.join(','); // Join the remaining parts with commas
//     return result;
//   }

//   Future<bool> checkInternetConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       } else {
//         return false;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//   }

//   // Future _shareQRImage(String data) async {
//   //   try {
//   //     final qrCode = QrCode.fromData(
//   //       data: data,
//   //       errorCorrectLevel: QrErrorCorrectLevel.H,
//   //     );

//   //     final qrImage = QrImage(qrCode);
//   //     final qrImageBytes = await qrImage.toImageAsBytes(
//   //       size: 512,
//   //       format: ImageByteFormat.png,
//   //       decoration: const PrettyQrDecoration(),
//   //     );
//   //   } catch (e) {
//   //     showErrorMessage(e.toString());
//   //   }
//   // }

//   Future _shareQRImage(String data) async {
//     final qrCode = QrCode.fromData(
//       data: data,
//       errorCorrectLevel: QrErrorCorrectLevel.H,
//     );
//     final qrImage = QrImage(qrCode);
//     final qrImageBytes = await qrImage.toImageAsBytes(
//       size: 512,
//       format: ImageByteFormat.png,
//       decoration: const PrettyQrDecoration(
//           shape: PrettyQrRoundedSymbol(),
//           background: Colors.white,
//           image: PrettyQrDecorationImage(
//             image: AssetImage('assets/icons/logo.png'),
//           )),
//     );

//     try {
//       // Step 1: Convert ByteData to Uint8List
//       Uint8List uint8List = qrImageBytes!.buffer.asUint8List();

//       // Step 2: Get a temporary directory to save the image
//       Directory tempDir = await getTemporaryDirectory();
//       String tempPath = '${tempDir.path}/shared_image.png';

//       // Step 3: Save the Uint8List as a file
//       File imageFile = File(tempPath);
//       await imageFile.writeAsBytes(uint8List);

//       // Step 4: Share the image using share_plus
//       await Share.shareFiles([imageFile.path], text: 'Generated qr image');
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//     }
//   }

//   Widget menu() {
//     return Container(
//       color: Colors.white,
//       width: 320,
//       padding: const EdgeInsets.only(bottom: 20.0, top: 30.0),
//       height: 90.0,
//       child: ListView.builder(
//         itemCount: ListData.qrMenu.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               setState(() {
//                 qrMenu = ListData.qrMenu[index]['name'];
//               });

//               for (int i = 0; i < ListData.qrMenu.length; i++) {
//                 ListData.qrMenu[i]['status'] = 0;
//               }
//               ListData.qrMenu[index]['status'] = 1;
//             },
//             child: Container(
//               width: 152,
//               margin: const EdgeInsets.only(right: 10.0),
//               decoration: customBoxDecoration(ListData.qrMenu[index]['status']),
//               child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(ListData.qrMenu[index]['name'],
//                         style: TextStyle(
//                             color: ListData.qrMenu[index]['status'] == 1
//                                 ? Colors.white
//                                 : Colors.black54,
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold))
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void getRollBack() async {
//     bool checkInternetStatus = await checkInternetConnection();

//     final status = Permission.contacts.request();

//     if (await status.isGranted) {
//       // permission has granted now save the contact here
//     }

//     if (checkInternetStatus == true) {
//       // scanResultMethod();
//     } else {
//       const snackBar = SnackBar(
//         backgroundColor: Colors.red,
//         content: Text('Please check your internet connection and try again'),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }

//   void openGoogleMapsApp() async {
//     const url =
//         'https://www.google.com/maps/dir/?api=1&destination=27.6872034,85.347528';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<LatLng?> getPlaceCoordinates(String placeId) async {
//     final apiKey = AppConstant.googleMapAPI;
//     final apiUrl =
//         'https://maps.googleapis.com/maps/api/geocode/json?address=$placeId&key=$apiKey';
//     // 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

//     try {
//       final response = await Dio().get(apiUrl);
//       final json = response.data;

//       final lat = json['results'][0]['geometry']['location']['lat'];
//       final lng = json['results'][0]['geometry']['location']['lng'];

//       return LatLng(lat, lng);
//     } catch (e) {
//       // Handle error
//       print(e);
//       return null;
//     }
//   }
// }
