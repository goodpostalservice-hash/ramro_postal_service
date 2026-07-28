import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/privacy_data.dart';
import '../repositories/settings_repository.dart';

class GetPrivacyPolicyUseCase extends UseCase<PrivacyData, NoParams> {
  final SettingsRepository repository;

  GetPrivacyPolicyUseCase(this.repository);

  @override
  Future<Either<Failure, PrivacyData>> call(NoParams params) {
    return repository.getPrivacyPolicy();
  }
}
