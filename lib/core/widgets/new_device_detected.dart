import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/features/auth/presentation/pages/otp.dart';

import '../../routes/app_routes.dart';

void showNewDeviceBottomSheet({required String phone}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_android_rounded, size: 48),

            const SizedBox(height: 16),

            Text(
              'New Device Detected',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Your account is already registered on another device. Do you want to authorize this device?',
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('No'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      OTPScreen.phone = phone;
                      Get.back();

                      Get.toNamed(AppRoutes.otp);
                    },
                    child: const Text('Yes, Authorize'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
  );
}
