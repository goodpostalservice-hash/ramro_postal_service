import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/register_request.dart';
import '../../data/models/register_response.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<RegisterResponse, RegisterRequest> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, RegisterResponse>> call(RegisterRequest request) {
    return repository.register(request);
  }
}
