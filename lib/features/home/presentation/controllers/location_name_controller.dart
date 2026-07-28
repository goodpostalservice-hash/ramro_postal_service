// import 'dart:async';

// import 'package:dio/dio.dart' as dio;
// import 'package:get/get.dart' hide Response;
// import 'package:ramro_postal_service/base/base_controller.dart';
// import 'package:ramro_postal_service/core/constants/address_split.dart';
// import 'package:ramro_postal_service/core/constants/app_export.dart';
// import 'package:ramro_postal_service/core/network/network_dio.dart';
// import 'package:ramro_postal_service/screen/home_map/home_map_screen/model/location_data_model.dart';

// import 'package:dio/dio.dart' ;

// class LocationNameController extends BaseController {
//   Rxn<LocationDataModel> locationData = Rxn<LocationDataModel>();
//   RxString locationName = ''.obs;

//   final Dio _dio = Dio();

// Future<String?> getLocationName({
//   required double latitude,
//   required double longitude,
// }) async {
//   final map = {
//     "latitude": latitude,
//     "longitude": longitude,
//   };

//   try {
//     final result = await restClient.request(
//       ApiConstant.locationName,
//       Method.GET,
//       map,
//     );

//     if (result != null && result is dio.Response) {
//       final responseData = LocationDataModel.fromJson(result.data);

//       locationData.value = responseData;

//       final address = responseData.data?.fullAddressDetail?.trim() ?? '';

//       if (address.isNotEmpty) {
//         locationName.value = splitCoordinateString(address);
//         return splitCoordinateString(address);
//       }
//     }

//     // If API success but no address
//     return await getGoogleLocationName(latitude, longitude);
//   } catch (e) {
//     print("getLocationName error => $e");

//     // Your 404 comes here, so fallback here
//     final googleAddress = await getGoogleLocationName(latitude, longitude);

//     locationName.value = googleAddress;
//     return googleAddress;
//   }
// }
// }
