import 'package:dartz/dartz.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ramro_postal_service/app/core/configuration/http_config.dart';
import 'package:ramro_postal_service/app/data/models/estimate_cost_response/estimate_cost_response.dart';
import 'package:ramro_postal_service/app/data/models/order_detail_response/order_detail_response.dart';
import 'package:ramro_postal_service/app/data/params/estimate_cost_param.dart';

import '../../../core/configuration/api.dart';
import '../../params/place_order_param.dart';

class OrderDetailService {
  static Future<Either<String, OrderDetailResponse>> getOrderDetail({
    required int orderId,
  }) async {
    var res = await SApi().get(
      HttpConfig.orderDetail(orderId),
      addAuthInterceptor: true,
    );

    if (res.isSuccess) {
      late OrderDetailResponse data;
      try {
        data = OrderDetailResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }

  static Future<Either<String, EstimateCostResponse>> calculateEstimate({
    required EstimateCostParam param,
  }) async {
    var res = await SApi().post(
      HttpConfig.orderEstimate,
      data: param.toMap(),
      addAuthInterceptor: true,
    );

    if (res.data != null) {
      late EstimateCostResponse data;
      try {
        data = EstimateCostResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }

  static Future<Either<String, OrderDetailResponse>> placeOrder({
    required PlaceOrderParam params, required BuildContext context,
  }) async {
    var res = await SApi().post(
      HttpConfig.placeOrder,
      data: params.toFormData(),
      addAuthInterceptor: true,
    );

    if (res.isSuccess) {
      late OrderDetailResponse data;
      try {
        data = OrderDetailResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }
}
