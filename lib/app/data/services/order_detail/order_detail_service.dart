import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/app/core/configuration/http_config.dart';
import 'package:ramro_postal_service/app/data/models/order_detail_response/order_detail_response.dart';

import '../../../core/configuration/api.dart';

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
}
