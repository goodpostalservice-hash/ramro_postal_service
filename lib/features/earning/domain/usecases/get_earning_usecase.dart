import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/earning_response.dart';
import '../repositories/earning_repository.dart';

class GetEarningUseCase extends UseCase<EarningResponse, NoParams> {
  final EarningRepository repository;

  GetEarningUseCase(this.repository);

  @override
  Future<Either<Failure, EarningResponse>> call(NoParams params) {
    return repository.getEarning();
  }
}
