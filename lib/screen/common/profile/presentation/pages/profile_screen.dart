import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/common/search/presentation/view/google_search_screen.dart';
import '../../../../main/widget/small_outline_button.dart';
import '../../controller/profile_controller.dart';

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
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Material(
            color: appTheme.gray50,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ),
        title: Text(
          'My profile',
          style: TextStyle(
            color: AppColors.blackBold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => controller.isToLoadMore.value
            ? const Center(child: CircularProgressIndicator())
            : _Body(controller: controller),
      ),
      bottomNavigationBar: Obx(() {
        if (!_isEditing) return const SizedBox.shrink();
        return _BottomActions(
          isLoading: controller.isUpdateLoading.value,
          onCancel: controller.handleClick, // toggles back to view mode
          onUpdate: () {
            controller.updateUserProfile(
              controller.firstNameController.text,
              controller.lastNameController.text,
              controller.emailController.text,
              controller.addressController.text,
              controller.dobController.text,
            );
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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

          const SizedBox(height: 16),

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
          const SizedBox(height: 6),
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
              onTap: () =>
                  Get.to(() => const GoogleSearchScreen(pickLocation: 2)),
            ),
          ),

          // bottom spacer so content isn't hidden behind buttons
          SizedBox(height: _isEditing ? 96 : 16),
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar (centered)
          CircleAvatar(
            radius: 46,
            backgroundColor: appTheme.gray200,
            backgroundImage: const NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            ),
          ),
          const SizedBox(height: 10),

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
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackBold,
          fontSize: 14,
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
    borderRadius: BorderRadius.circular(15),
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
          readOnly: true,
          style: TextStyle(color: AppColors.blackBold, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(color: appTheme.gray500, fontSize: 14),
            suffixIcon: Icon(
              Icons.location_on_outlined,
              size: 20,
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            // Cancel (outlined)
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: BorderSide(color: appTheme.orange25, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: appTheme.orangeBase,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Update (filled orange)
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onUpdate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  elevation: 0,
                  backgroundColor: appTheme.orangeBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isLoading ? 'Updating...' : 'Update profile',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
