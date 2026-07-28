import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../../core/usecases/usecase.dart';
import '../controllers/auth_controller.dart';

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LogoutDialog(),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.gray25,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: appTheme.orangeBase.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: appTheme.orangeBase,
                size: 26,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Logout',
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeButton500.copyWith(
                color: appTheme.gray900,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Are you sure you want to logout from your account?',
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeButton500.copyWith(
                color: appTheme.gray500,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outlined,
                    height: 44,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => Expanded(
                    child: AppButton(
                      label: 'Logout',
                      variant: AppButtonVariant.filled,
                      height: 44,
                      isLoading: Get.find<AuthController>().isLoggingOut.value,
                      onPressed: () async {
                        final authController = Get.find<AuthController>();
                        await authController.logout();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
