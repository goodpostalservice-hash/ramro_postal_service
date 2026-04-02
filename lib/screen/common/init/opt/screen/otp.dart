import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ramro_postal_service/core/constants/app_constant.dart';
import 'package:ramro_postal_service/core/widgets/custom_button.dart';
import 'package:ramro_postal_service/screen/main/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../app/core/utils/storage_util.dart';
import '../../../../../core/constants/app_export.dart';
import '../../../../../core/error/toast.dart';
import '../../register/screen/register.dart';

class OTPScreen extends StatefulWidget {
  static String phone = '';

  const OTPScreen({super.key});

  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  final _fieldOne = TextEditingController();

  bool get _canSubmit => _fieldOne.text.trim().length == 6;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  /// More efficient timer state: update only a small part of the UI with a ValueNotifier.
  final ValueNotifier<int> _remaining = ValueNotifier<int>(59);
  Timer? _timer;

  // ====== LIFECYCLE ======
  @override
  void initState() {
    super.initState();
    _startTimer();

    _fieldOne.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fieldOne.dispose();
    _remaining.dispose();
    super.dispose();
  }

  // ====== TIMER ======
  void _startTimer() {
    _timer?.cancel();
    _remaining.value = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = _remaining.value - 1;
      if (!mounted) return;
      if (next <= 0) {
        _remaining.value = 0;
        timer.cancel();
      } else {
        _remaining.value = next;
      }
    });
  }

  // ====== BUILD ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: getPadding(left: 16, top: 21, right: 16, bottom: 21),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Container(
                  width: getHorizontalSize(40.0),
                  height: getVerticalSize(40.0),
                  decoration: BoxDecoration(
                    color: appTheme.gray50,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Headline
                Padding(
                  padding: EdgeInsets.only(top: getVerticalSize(24.0)),
                  child: Text(
                    "Enter code",
                    style: CustomTextStyles.headlineMedium_32_600,
                  ),
                ),

                // Subtext
                Padding(
                  padding: EdgeInsets.only(top: getVerticalSize(10.0)),
                  child: Text(
                    "Your temporary login code was \n sent to (977) ${OTPScreen.phone}",
                    maxLines: 2,
                    style: CustomTextStyles.bodyMediumGray14_400,
                  ),
                ),

                const SizedBox(height: 16.0),

                // Pinput
                Padding(
                  padding: EdgeInsets.only(top: getVerticalSize(32.0)),
                  child: Pinput(
                    errorTextStyle: const TextStyle(color: Colors.red),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    disabledPinTheme: const PinTheme(
                      padding: EdgeInsets.only(left: 9.0, right: 9.0),
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                    controller: _fieldOne,
                    length: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter valid code";
                      }
                      return null;
                    },
                    errorPinTheme: PinTheme(
                      padding: const EdgeInsets.only(left: 8.5, right: 8.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      textStyle: CustomTextStyles.bodyErrorStyle,
                      width: getHorizontalSize(50),
                      height: getHorizontalSize(50),
                    ),
                    defaultPinTheme: PinTheme(
                      padding: getPadding(left: 8.5, right: 8.5),
                      width: getHorizontalSize(50),
                      height: getHorizontalSize(50),
                      textStyle: CustomTextStyles.bodyMediumBlack14_400,
                      decoration: BoxDecoration(
                        border: Border.all(color: appTheme.grayScale300),
                        color: appTheme.white,
                        borderRadius: BorderRadius.circular(
                          getHorizontalSize(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.0),
                // Verify button
                AppButton(
                  label: 'Verify OTP',
                  isLoading: _isLoading,
                  loadingText: 'Verifying',
                  onPressed: _canSubmit
                      ? () {
                          setState(() => _isLoading = true);
                          if (_fieldOne.text.isNotEmpty) {
                            _verifyOTP();
                          }
                        }
                      : null,
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: _canSubmit
                  //       ? appTheme.orangeBase
                  //       : appTheme.gray200,
                  // ),
                ),

                // Didn't receive section + counter (only this part rebuilds every second)
                ValueListenableBuilder<int>(
                  valueListenable: _remaining,
                  builder: (_, time, __) => _didntReceivedCodeSection(time),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====== UI bits ======
  Widget _didntReceivedCodeSection(int time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            time == 0
                ? await showOtpHelpBottomSheet(
                    context,
                    phone: '+977 ${OTPScreen.phone}',
                    onEditNumber: () {
                      // open edit phone screen
                    },
                    onResend: () {
                      // trigger resend code
                    },
                    onNeedHelp: () {
                      // open support or send logs
                    },
                  )
                : null;
          },
          child: Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn't received a code?",
                      style: CustomTextStyles.bodyMediumGray600,
                    ),
                    TextSpan(
                      text: ' Send again',
                      style: time == 0
                          ? CustomTextStyles.titleSmallBlack
                          : CustomTextStyles.bodyMediumGray14_400,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(time.toString()),
        ),
        // If you decide to re-enable resend button later, just call _resendOTP()
        // when time == 0. Keeping your logic as-is for now.
      ],
    );
  }

  Future<void> showOtpHelpBottomSheet(
    BuildContext context, {
    required String phone,
    VoidCallback? onEditNumber,
    VoidCallback? onResend,
    VoidCallback? onNeedHelp,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // keep edges transparent
      barrierColor: Colors.black54, // dim background a bit
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;

        return Padding(
          // 1) global margins on all sides
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
          child: SafeArea(
            top: false,
            child: Align(
              // 2) keep it near the bottom but not touching
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Container(
                  // 3) floating card look
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    // inner content padding
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Sorry',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(ctx).pop(),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Body text
                        Text(
                          "If you didn’t get the code by SMS or call, please check your cellular data settings and phone number:",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withOpacity(0.65),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Phone (bold)
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          "Your remaining options are to try another number or to contact Ramro postal support. Tap help to send us the technical details so that we can identify the problem.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withOpacity(0.65),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Need help link
                        GestureDetector(
                          onTap: onNeedHelp,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            'Need help?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Buttons row
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'Edit number',
                                onPressed: onEditNumber,
                                variant: AppButtonVariant.outlined,
                              ),
                            ),

                            const SizedBox(width: 12),
                            Expanded(
                              child: AppButton(
                                label: 'Resend again',
                                onPressed: onResend,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ====== API CALLS ======

  // verify otp
  Future<void> _verifyOTP() async {
    // guard if already verifying
    if (!_canSubmit) return; // guard
    final dio = Dio();
    final payload = {'otp': _fieldOne.text.trim(), 'phone': OTPScreen.phone};

    Response? response;
    try {
      response = await dio.post(
        ApiConstant.verify,
        options: Options(headers: {'Accept': 'application/json'}),
        data: FormData.fromMap(payload),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false); // allow retry
      showErrorMessage('Something went wrong while verifing.');
      return;
    }

    if (response.data == null) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      showErrorMessage('Invalid server response.');
      return;
    }

    final responseData = response.data;
    final success = responseData['success'] == true;

    if (!mounted) return;

    if (success) {
      // Clear any old session
      AppConstant.logInfo = [];

      // Persist response data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      AppConstant.bearerToken = responseData['data']['token'];
      SStorageUtil.saveAuthData(
        accessToken: AppConstant.bearerToken,
        refreshToken: "",
      );

      final Map<String, dynamic> map = responseData;
      await prefs.setString('key', json.encode(map));

      // Reflect in memory list
      AppConstant.logInfo.add(response.data);

      showSuccessMessage(responseData['message'].toString());
      RegisterScreen.phone = OTPScreen.phone;

      // Navigate to dashboard
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      showErrorMessage(responseData['message'].toString());
    }
  }

  Future<void> _resendOTP() async {
    final dio = Dio();
    final payload = {'phone': OTPScreen.phone};

    Response? response;
    try {
      response = await dio.post(
        ApiConstant.resendOtp,
        options: Options(headers: {'Accept': 'application/json'}),
        data: FormData.fromMap(payload),
      );
    } catch (_) {
      showErrorMessage('Something went wrong while verifing.');
      return;
    }

    final responseData = response.data;
    final success = responseData['success'] == true;

    if (success) {
      showSuccessMessage(responseData['message']);
      // reset timer & disable button until code is retyped
      _timer?.cancel();
      _remaining.value = 59;
      _startTimer();
      setState(() {}); // reflect button color change immediately
    } else {
      showErrorMessage(responseData['message'].toString());
    }
  }
}
