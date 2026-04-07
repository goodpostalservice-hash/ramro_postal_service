import 'package:dartz/dartz.dart';
import 'package:ramro_postal_service/app/core/configuration/http_config.dart';
import 'package:ramro_postal_service/app/data/models/earning_response.dart';
import 'package:ramro_postal_service/app/data/models/today_earning_response.dart';

import '../../../core/configuration/api.dart';

class EarningDashboardService {
  static Future<Either<String, TodayEarningResponse>> getTodayEarning() async {
    var res = await SApi().get(
      HttpConfig.todayEarning,
      addAuthInterceptor: true,
    );

    if (res.isSuccess) {
      late TodayEarningResponse data;
      try {
        data = TodayEarningResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }

  static Future<Either<String, EarningResponse>> getEarning() async {
    var res = await SApi().get(HttpConfig.earning, addAuthInterceptor: true);

    if (res.isSuccess) {
      late EarningResponse data;
      try {
        data = EarningResponse.fromMap(res.data ?? {});
      } catch (e) {
        return Left("data parsing error: $e");
      }
      return Right(data);
    } else {
      return Left(res.message ?? "something went wrong");
    }
  }
}
