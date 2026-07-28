import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<LoginResponse, LoginRequest> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginRequest request) {
    return repository.login(request);
  }
}
