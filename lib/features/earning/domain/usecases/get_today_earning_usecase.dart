import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/today_earning_response.dart';
import '../repositories/earning_repository.dart';

class GetTodayEarningUseCase extends UseCase<TodayEarningResponse, NoParams> {
  final EarningRepository repository;

  GetTodayEarningUseCase(this.repository);

  @override
  Future<Either<Failure, TodayEarningResponse>> call(NoParams params) {
    return repository.getTodayEarning();
  }
}
