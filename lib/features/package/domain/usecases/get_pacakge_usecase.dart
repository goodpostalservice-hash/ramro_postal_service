import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/available_package.dart';
import '../repositories/package_repository.dart';

class GetPacakgeUseCase extends UseCase<List<AvailablePackageModel>, NoParams> {
  final PackageRepository repository;

  GetPacakgeUseCase(this.repository);

  @override
  Future<Either<Failure, List<AvailablePackageModel>>> call(NoParams params) {
    return repository.getPacakge();
  }
}
