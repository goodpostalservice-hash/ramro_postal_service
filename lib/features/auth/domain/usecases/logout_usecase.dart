import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/logout_response.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<LogOutResponse, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, LogOutResponse>> call(NoParams params) {
    return repository.logout();
  }
}
