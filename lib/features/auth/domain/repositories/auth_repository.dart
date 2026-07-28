import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';
import '../../data/models/register_request.dart';
import '../../data/models/register_response.dart';
import '../../data/models/otp_check_request.dart';
import '../../data/models/otp_response.dart';
import '../../data/models/resend_otp_request.dart';
import '../../data/models/resend_otp_response.dart';
import '../../data/models/logout_response.dart';
abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);

  Future<Either<Failure, OtpResponse>> checkOtp(OtpCheckRequest request);

  Future<Either<Failure, ResendOtpResponse>> resendOtp(ResendOtpRequest request);

  Future<Either<Failure, LogOutResponse>> logout();

}
