import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/today_earning_response.dart';
import '../../data/models/earning_response.dart';
abstract class EarningRepository {
  Future<Either<Failure, TodayEarningResponse>> getTodayEarning();

  Future<Either<Failure, EarningResponse>> getEarning();

}
