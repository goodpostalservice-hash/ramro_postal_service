import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/auth/data/models/register_request.dart';
import 'package:ramro_postal_service/features/auth/presentation/controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  static String phone = '';

  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool showPassword = false;

  final formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late bool initButton;

  int userTypeId = 1;

  int id = 1;

  @override
  void initState() {
    super.initState();
    initButton = false;
  }

  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SingleChildScrollView(
        child: Container(
          padding: AppSpacing.pageHorizontalPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context),
                Text(
                  'Create Your Account',
                  style: CustomTextStyles.headlineMedium_32_600,
                ),
                Padding(
                  padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
                  child: Text(
                    'Enter full name',
                    style: CustomTextStyles.bodyMediumBlack1000_14_500,
                  ),
                ),
                formWidget(),
                AppSpacing.gapLg,
                submitWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextFormField(
          controller: _firstNameController,
          hint: 'First name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your first name.";
            }
            return null;
          },
        ),
        CustomTextFormField(
          controller: _lastNameController,
          hint: 'Last name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your last name.";
            }
            return null;
          },
        ),
        Padding(
          padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
          child: Text(
            'Enter your email',
            style: CustomTextStyles.bodyMediumBlack1000_14_500,
          ),
        ),
        CustomTextFormField(
          controller: _emailController,
          hint: 'Enter your email address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your email.";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget submitWidget() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => AppButton(
          onPressed: () {
            final request = RegisterRequest(
              firstName: _firstNameController.text.toString(),
              lastName: _lastNameController.text.toString(),
              email: _emailController.text.toString(),
              countryCode: '977',
              phone: authController.phoneController.text.toString(),
            );

            if (formKey.currentState!.validate()) {
              authController.register(request);
            }
          },
          isLoading: authController.isRegistering.value,
          loadingText: 'Please wait'.toUpperCase(),
          label: 'Register Account'.toUpperCase(),
          borderRadius: AppRadius.textField,
        ),
      ),
    );
  }
}
