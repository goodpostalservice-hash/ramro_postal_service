import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/profile/data/models/update_profile_request.dart';
import 'package:ramro_postal_service/features/search/presentation/bindings/search_binding.dart';

import '../../../../core/widgets/outline_small_button.dart';
import '../../../search/data/models/search_response.dart';
import '../../../search/presentation/pages/google_search_screen.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  bool get _isEditing => !controller.isButtonVisible.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appTheme.gray25,
        automaticallyImplyLeading: false,
        leadingWidth: AppSizes.avatarXl,
        leading: Padding(
          padding: AppSpacing.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm + AppSpacing.xxs,
          ),
          child: Material(
            color: appTheme.gray50,
            borderRadius: AppRadius.cardRadius,
            child: InkWell(
              borderRadius: AppRadius.cardRadius,
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                width: AppSpacing.colossal,
                height: AppSpacing.colossal,
                child: Icon(Icons.arrow_back, color: appTheme.black),
              ),
            ),
          ),
        ),
        title: Text(
          'My profile',
          style: TextStyle(color: appTheme.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _Body(controller: controller),
      ),
      bottomNavigationBar: Obx(() {
        if (!_isEditing) return const SizedBox.shrink();
        return _BottomActions(
          isLoading: controller.isUpdateLoading.value,
          onCancel: controller.handleClick, // toggles back to view mode
          onUpdate: () {
            final updateReq = UpdateProfileRequest(
              firstName: controller.firstNameController.text,
              lastName: controller.lastNameController.text,
              email: controller.emailController.text,
              address: controller.addressController.text,
              phone: controller.phoneController.text,
            );
            controller.updateProfile(updateReq);
          },
        );
      }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final ProfileController controller;

  bool get _isEditing => !controller.isButtonVisible.value;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppSpacing.only(
        left: AppSpacing.screenHorizontal,
        top: AppSpacing.sm,
        right: AppSpacing.screenHorizontal,
        bottom: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Align(
              alignment: Alignment.center,
              child: _ProfileHeader(
                firstName: controller.resultList.subject.value?.firstName ?? '',
                lastName: controller.resultList.subject.value?.lastName ?? '',
                email: controller.resultList.subject.value?.email ?? '',
                showEditButton: controller.isButtonVisible.value,
                onEditTap: controller.handleClick,
              ),
            ),
          ),

          AppSpacing.gapLg,

          // ===== Full name section =====
          _FieldLabel('Enter full name'),
          // Text(
          //   'Enter full name',
          //   style: TextStyle(
          //     color: AppColors.blackBold,
          //     fontSize: 14,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          AppSpacing.gapXs,
          Column(
            children: [
              Obx(
                () => CustomTextFormField(
                  controller: controller.firstNameController,
                  hint: 'First name',
                  onChanged: (_) {},
                  validator: null,
                  isReadOnly: controller.isButtonVisible.value == false
                      ? false
                      : true,
                ),
              ),
              Obx(
                () => CustomTextFormField(
                  controller: controller.lastNameController,
                  hint: 'Last name',
                  onChanged: (_) {},
                  validator: null,
                  isReadOnly: controller.isButtonVisible.value == false
                      ? false
                      : true,
                ),
              ),
            ],
          ),

          // ===== Email =====
          _FieldLabel('Email address'),
          Obx(
            () => CustomTextFormField(
              controller: controller.emailController,
              hint: 'Enter email address',
              isReadOnly: controller.isButtonVisible.value == false
                  ? false
                  : true,
            ),
          ),

          // ===== Phone (read-only) =====
          _FieldLabel('Phone number'),
          Obx(
            () => CustomTextFormField(
              controller: controller.phoneController,
              hint: 'Phone number',
              isReadOnly: controller.isButtonVisible.value == false
                  ? false
                  : true,
            ),
          ),

          // ===== Address (opens search) =====
          _FieldLabel('Address'),
          Obx(
            () => _TapToPickField(
              controller: controller.addressController,
              hint: 'Enter your address',
              isReadOnly: controller.isButtonVisible.value == false
                  ? false
                  : true,
              onTap: controller.isButtonVisible.value == false
                  ? () async {
                      final result = await Get.to(
                        () => const GoogleSearchScreen(pickAddress: true),
                        binding: SearchBinding(),
                      );
                      if (result != null && result is SearchAddress) {
                        controller.addressController.text =
                            result.fullAddressDetail ??
                            result.locationName ??
                            '';
                      }
                    }
                  : () {},
            ),
          ),

          // bottom spacer so content isn't hidden behind buttons
          SizedBox(height: _isEditing ? AppSizes.logoLg : AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.firstName, // kept for compatibility (not shown)
    required this.lastName, // kept for compatibility (not shown)
    required this.email, // kept for compatibility (not shown)
    required this.showEditButton,
    required this.onEditTap,
  });

  final String firstName;
  final String lastName;
  final String email;
  final bool showEditButton;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.lg + AppSpacing.xxs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar (centered)
          CircleAvatar(
            radius: AppSpacing.mega + AppSpacing.xxs,
            backgroundColor: appTheme.gray200,
            backgroundImage: const NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            ),
          ),
          AppSpacing.gapSm,

          // Edit chip (centered)
          if (showEditButton)
            OutlineSmallButton(
              icon: Icons.edit,
              label: ' Edit profile',
              onTap: onEditTap,
            ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.only(
        top: AppSpacing.md + AppSpacing.xxs,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: appTheme.black,
          fontSize: AppTheme.light.textTheme.bodyMedium?.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Tappable, read-only field that opens place picker (Address)
class _TapToPickField extends StatelessWidget {
  const _TapToPickField({
    required this.controller,
    required this.hint,
    required this.onTap,
    this.isReadOnly = false,
  });

  final TextEditingController controller;
  final String hint;
  final bool? isReadOnly;
  final VoidCallback onTap;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: AppRadius.textFieldRadius,
    borderSide: BorderSide(color: c, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    final border = appTheme.gray400;
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          readOnly: isReadOnly ?? false,
          style: CustomTextStyles.bodyMediumBlack14_400,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: AppSpacing.inputContentPadding,
            filled: true,
            fillColor: appTheme.white,

            hintText: hint,
            hintStyle: CustomTextStyles.bodyMediumGray600,
            suffixIcon: Icon(
              Icons.location_on_outlined,
              size: AppSizes.iconMd,
              color: appTheme.gray500,
            ),
            border: _border(border),
            enabledBorder: _border(border),
            focusedBorder: _border(border),
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.isLoading,
    required this.onCancel,
    required this.onUpdate,
  });

  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Cancel (outlined)
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                  side: BorderSide(color: appTheme.orange25, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonRadius,
                  ),
                  backgroundColor: appTheme.white,
                  foregroundColor: appTheme.orangeBase,
                ),
                child: Text(
                  'Cancel',
                  style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                    color: appTheme.orangeBase,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalGapMd,
            // Update (filled orange)
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onUpdate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
                  elevation: 0,
                  backgroundColor: appTheme.orangeBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonRadius,
                  ),
                  foregroundColor: appTheme.white,
                ),
                child: Text(
                  isLoading ? 'Updating...' : 'Update profile',
                  style: CustomTextStyles.bodyLargeButton500.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
