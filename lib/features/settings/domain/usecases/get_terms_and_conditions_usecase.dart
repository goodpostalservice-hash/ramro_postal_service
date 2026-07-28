import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/terms_data.dart';
import '../repositories/settings_repository.dart';

class GetTermsAndConditionsUseCase extends UseCase<TermsData, NoParams> {
  final SettingsRepository repository;

  GetTermsAndConditionsUseCase(this.repository);

  @override
  Future<Either<Failure, TermsData>> call(NoParams params) {
    return repository.getTermsAndConditions();
  }
}
