import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/app/data/params/estimate_cost_param.dart';
import 'package:ramro_postal_service/app/data/params/place_order_param.dart';
import 'package:ramro_postal_service/app/data/services/order_detail/order_detail_service.dart';

import '../../../../../app/core/utils/snackbar_util.dart';
import '../../../../../app/data/models/estimate_cost_response/estimate_cost_response.dart';
import '../../../../../app/data/models/general/api_result.dart';
import '../../../../../app/data/models/order_detail_response/order_detail_response.dart';

class PlaceOrderController extends GetxController {
  PlaceOrderController();

  var estimateCostResult = APIResult<EstimateCostResponse>().obs;

  Future<void> getEstimateCost({required EstimateCostParam param}) async {
    estimateCostResult.value = APIResult.loading();

    var response = await OrderDetailService.calculateEstimate(param: param);
    estimateCostResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (estimateCostResult.value.isSuccessful) {
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        estimateCostResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }

  var placeOrderResult = APIResult<OrderDetailResponse>().obs;

  Future<void> placeOrder({
    required PlaceOrderParam param,
    required BuildContext context,
  }) async {
    placeOrderResult.value = APIResult.loading();

    var response = await OrderDetailService.placeOrder(
      params: param,
      context: context,
    );
    placeOrderResult.value = response.fold(
      (l) => APIResult.error(l),
      (r) => APIResult.success(r),
    );

    if (placeOrderResult.value.isSuccessful) {
      Navigator.pop(context);
    } else {
      SSnackbarUtil.showSnackbar(
        "Error",
        placeOrderResult.value.error ?? "Something went wrong",
        SnackbarType.error,
      );
    }
  }
}
