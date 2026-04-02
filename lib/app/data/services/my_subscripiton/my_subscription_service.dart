import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/app/core/configuration/http_config.dart';
import 'package:ramro_postal_service/app/data/models/my_subscription_response/my_subscription_response.dart';

import '../../../core/configuration/api.dart';

class MySubscriptionService {
  static Future<Either<String, MySubscriptionResponse>> getMySubscription() async {
    var res = await SApi().get(HttpConfig.subscription, addAuthInterceptor: true);

    if (res.isSuccess) {
      late MySubscriptionResponse data;
      try {
        data = MySubscriptionResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }
}
