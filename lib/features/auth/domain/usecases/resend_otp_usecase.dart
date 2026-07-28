import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/resend_otp_request.dart';
import '../../data/models/resend_otp_response.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase extends UseCase<ResendOtpResponse, ResendOtpRequest> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, ResendOtpResponse>> call(ResendOtpRequest request) {
    return repository.resendOtp(request);
  }
}
