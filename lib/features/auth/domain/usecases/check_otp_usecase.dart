import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/otp_check_request.dart';
import '../../data/models/otp_response.dart';
import '../repositories/auth_repository.dart';

class CheckOtpUseCase extends UseCase<OtpResponse, OtpCheckRequest> {
  final AuthRepository repository;

  CheckOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpResponse>> call(OtpCheckRequest request) {
    return repository.checkOtp(request);
  }
}
