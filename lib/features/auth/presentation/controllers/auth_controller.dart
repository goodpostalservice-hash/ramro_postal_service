import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/const_keys.dart';
import 'package:ramro_postal_service/core/storage/storage_util.dart';
import 'package:ramro_postal_service/features/auth/presentation/pages/otp.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/models/login_request.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/models/register_request.dart';
import '../../domain/usecases/check_otp_usecase.dart';
import '../../data/models/otp_check_request.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../data/models/resend_otp_request.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  // USECASE_FIELDS_START

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckOtpUseCase checkOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final LogoutUseCase logoutUseCase;
  // USECASE_FIELDS_END

  AuthController({
    // USECASE_CONSTRUCTOR_START
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkOtpUseCase,
    required this.resendOtpUseCase,
    required this.logoutUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  final isVerifying = false.obs;
  final isResending = false.obs;
  final isRegistering = false.obs;
  final isLoggingOut = false.obs;
  final TextEditingController phoneController = TextEditingController();
  final secureStorage = SecureStorageService();

  // API_METHODS_START
  // API_METHODS_END

  void _showSnack(String message, {required bool isError}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.context ?? Get.key.currentContext;

      if (context == null) return;

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) return;

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  Future<void> login(LoginRequest request) async {
    try {
      isLoading.value = true;

      final result = await loginUseCase(request);

      await result.fold<Future<void>>(
        (failure) async {
          _showSnack(failure.message, isError: true);
        },
        (response) async {
          final token = response.data?.token;

          if (response.success == true && response.isVerified == true) {
            await Get.find<SecureStorageService>().saveAccessToken(token!);

            await SStorageUtil.saveUserData(
              userData: UserData(
                name:
                    "${response.data!.user!.firstName!} ${response.data!.user!.lastName!}",
                email: response.data!.user!.email!,
                phone: response.data!.user!.phone!,
                userType: response.data!.user!.userType ?? 'driver',
              ),
            );

            await SStorageUtil.saveData(
              key: SConstKeys.isLoggedIn,
              value: true,
            );
            Get.offAllNamed(AppRoutes.dashboard);
          }
          if (response.isVerified == false) {
            if (response.verification!.phone == false &&
                response.verification!.kyc == false) {
              OTPScreen.phone = request.phone;
              Get.toNamed(AppRoutes.otp);
              return;
            } else if (response.verification!.phone == true &&
                response.verification!.kyc == false) {
              Get.toNamed(AppRoutes.register);
              return;
            } else if (response.verification!.phone == false &&
                response.verification!.kyc == true) {
              OTPScreen.phone = request.phone;
              Get.toNamed(AppRoutes.otp);
              return;
            }
          }
        },
      );
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      isRegistering.value = true;

      final result = await registerUseCase(request);

      result.fold(
        (failure) {
          _showSnack(failure.message, isError: true);
        },
        (response) async {
          await Get.find<SecureStorageService>().saveAccessToken(
            response.data!.token!,
          );
          await SStorageUtil.saveUserData(
            userData: UserData(
              name:
                  "${response.data!.user!.firstName!} ${response.data!.user!.lastName!}",
              email: response.data!.user!.email!,
              phone: response.data!.user!.phone!,
              userType: response.data!.user!.userType!,
            ),
          );

          await SStorageUtil.saveData(key: SConstKeys.isLoggedIn, value: true);
          Get.offAllNamed(AppRoutes.dashboard);
        },
      );
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    } finally {
      isRegistering.value = false;
    }
  }

  Future<void> checkOtp(OtpCheckRequest request) async {
    try {
      isVerifying.value = true;

      final result = await checkOtpUseCase(request);

      result.fold(
        (failure) {
          _showSnack(failure.message, isError: true);
        },
        (response) async {
          _showSnack(
            response.message ?? "OTP verified successfully",
            isError: false,
          );
          if (response.success == false) {
            _showSnack(
              response.message ?? "Failed to verify OTP",
              isError: true,
            );
            return;
          } else {
            if (response.data?.user?.iskycVerified == 0 ||
                response.data == null) {
              Get.offAllNamed(AppRoutes.register);
              return;
            } else {
              await Get.find<SecureStorageService>().saveAccessToken(
                response.data!.token!,
              );

              await SStorageUtil.saveUserData(
                userData: UserData(
                  name:
                      "${response.data!.user!.firstName!} ${response.data!.user!.lastName!}",
                  email: response.data!.user!.email!,
                  phone: response.data!.user!.phone!,
                  userType: response.data!.user!.userType!,
                ),
              );
              await SStorageUtil.saveData(
                key: SConstKeys.isLoggedIn,
                value: true,
              );
              Get.offAllNamed(AppRoutes.dashboard);
              return;
            }
          }
        },
      );
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendOtp(ResendOtpRequest request) async {
    try {
      isResending.value = true;

      final result = await resendOtpUseCase(request);

      result.fold(
        (failure) {
          _showSnack(failure.message, isError: true);
        },
        (response) {
          Get.back(); // Navigate back to the previous screen
          _showSnack(
            response.message ?? 'Request completed successfully',
            isError: false,
          );
        },
      );
    } catch (e) {
      _showSnack(e.toString(), isError: true);
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    phoneController.dispose();
  }

  Future<void> logout() async {
    try {
      isLoggingOut.value = true;

      final result = await logoutUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) async {
          if (response.success == true) {
            await Get.find<SecureStorageService>().deleteAllTokens();
            await SStorageUtil.deleteUserData();
            await SStorageUtil.saveData(
              key: SConstKeys.isLoggedIn,
              value: false,
            );

            Get.snackbar('Success', 'Logged out successfully');
            Get.offAllNamed(AppRoutes.selectRole);
          } else {
            Get.back(); // Close the dialog if logout failed
            Get.snackbar('Error', response.message);
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoggingOut.value = false;
    }
  }
}
