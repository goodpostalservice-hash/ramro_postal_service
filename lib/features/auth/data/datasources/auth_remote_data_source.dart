import 'package:ramro_postal_service/core/constants/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/storage_util.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/otp_check_request.dart';
import '../models/otp_response.dart';
import '../models/resend_otp_request.dart';
import '../models/resend_otp_response.dart';
import '../models/logout_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<OtpResponse> checkOtp(OtpCheckRequest request);
  Future<ResendOtpResponse> resendOtp(ResendOtpRequest request);
  Future<LogOutResponse> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  const AuthRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.post(
      SStorageUtil.getUserData()!.userType == 'user'
          ? ApiConstant.login
          : ApiConstant.driverLogin,
      data: request.toJson(),
      needToken: false,
    );

    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await apiClient.post(
      ApiConstant.register,
      data: request.toJson(),
      needToken: false,
    );

    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<OtpResponse> checkOtp(OtpCheckRequest request) async {
    final response = await apiClient.post(
      SStorageUtil.getUserData()!.userType == 'user'
          ? ApiConstant.verify
          : ApiConstant.driverVerify,
      data: request.toJson(),
      needToken: false,
    );

    return OtpResponse.fromJson(response.data);
  }

  @override
  Future<ResendOtpResponse> resendOtp(ResendOtpRequest request) async {
    final response = await apiClient.post(
      SStorageUtil.getUserData()!.userType == 'user'
          ? ApiConstant.resendOtp
          : ApiConstant.driverResendOtp,
      data: request.toJson(),
      needToken: false,
    );

    return ResendOtpResponse.fromJson(response.data);
  }

  @override
  Future<LogOutResponse> logout() async {
    final response = await apiClient.get(
      SStorageUtil.getUserData()!.userType == 'user'
          ? ApiConstant.logout
          : ApiConstant.driverLogout,
      needToken: true,
    );

    return LogOutResponse.fromJson(response.data);
  }
}
