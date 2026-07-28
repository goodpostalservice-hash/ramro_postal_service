import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/otp_check_request.dart';
import '../models/otp_response.dart';
import '../models/resend_otp_request.dart';
import '../models/resend_otp_response.dart';
import '../models/logout_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final result = await remoteDataSource.login(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request) async {
    try {
      final result = await remoteDataSource.register(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, OtpResponse>> checkOtp(OtpCheckRequest request) async {
    try {
      final result = await remoteDataSource.checkOtp(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, ResendOtpResponse>> resendOtp(ResendOtpRequest request) async {
    try {
      final result = await remoteDataSource.resendOtp(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, LogOutResponse>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
