import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:ramro_postal_service/base/base_controller.dart';
import 'package:ramro_postal_service/core/constants/api_constant.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';

import '../model/order_history_model.dart';

class OrderHistoryController extends BaseController {
  final modelValue = OrderHistoryModel().obs;

  final isLoading = false.obs;

  List<Orders> get orders => modelValue.value.orders ?? [];

  Future<void> getOrderHistory() async {
    final map = <String, dynamic>{};

    try {
      final result = await restClient.request(
        ApiConstant.orderHistory,
        Method.GET,
        map,
      );

      if (result != null) {
        if (result is dio.Response) {
          // clear the list to replace with new value
          var responseData = OrderHistoryModel.fromJson(result.data);
          modelValue.value = responseData;

          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } on Exception {
      isLoading.value = false;
    }
  }
}
