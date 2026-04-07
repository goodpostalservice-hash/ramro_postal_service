// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:ramro_postal_service/core/constants/address_json.dart';
// import 'package:ramro_postal_service/core/constants/address_model.dart';
// import 'package:ramro_postal_service/core/constants/app_constant.dart';
// import 'package:ramro_postal_service/core/constants/boxes.dart';
// import 'package:ramro_postal_service/user/model/user_history_model.dart';
// import '../../../base/base_controller.dart';
// import '../../../core/constants/api_constant.dart';
// import '../../../core/error/toast.dart';
// import '../../../core/network/network_dio.dart';
// import 'package:dio/dio.dart' as dio;

// class AddressController extends BaseController {
//   List<AddressResponse> addressList = <AddressResponse>[].obs;
//   @override
//   onInit() {
//     super.onInit();
//     getAddress();
//   }

//   getAddress() async {
//     try {
//       final map = <String, dynamic>{};
//       final result =
//           await restClient.request(ApiConstant.address, Method.GET, map);

//       if (result != null) {
//         if (result is dio.Response) {
//           List<dynamic> myList = result.data;

//           addressBox.put('addressBox', myList);

//         }
//       } else {
//         print("error gettting data");
//       }
//     } on Exception catch (e) {
//       showErrorMessage('Something went wrong. Please try again later.');
//     }
//   }
// }
