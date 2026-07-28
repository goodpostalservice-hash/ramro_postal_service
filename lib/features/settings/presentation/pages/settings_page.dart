import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';

import '../../../../core/constants/app_exports.dart';
import '../../../../core/widgets/custom_app_widget.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  Future<void> _openPrivacyPolicy() async {
    Get.toNamed(AppRoutes.privacyPolicy);
  }

  Future<void> _openTermsAndConditions() async {
    Get.toNamed(AppRoutes.termsAndConditions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: backAppBar('Settings', context),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legal information',
                style: CustomTextStyles.headlineSmall_24_500,
              ),
              AppSpacing.gapSm,
              Text(
                'Review the policies and terms that apply when using Ramro Postal Service.',
                style: CustomTextStyles.bodyMediumGray600,
              ),
              AppSpacing.gapXxl,
              Container(
                decoration: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(color: appTheme.gray200),
                ),
                child: Column(
                  children: [
                    _SettingsTile(
                      leadingIcon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: _openPrivacyPolicy,
                    ),
                    Divider(
                      height: AppSpacing.none,
                      thickness: AppSizes.dividerThickness,
                      color: appTheme.gray200,
                    ),

                    _SettingsTile(
                      leadingIcon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: _openTermsAndConditions,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.leadingIcon,
    required this.title,
    required this.onTap,
  });

  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.cardRadius,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.giant,
              height: AppSpacing.giant,
              decoration: BoxDecoration(
                color: appTheme.gray200,
                borderRadius: AppRadius.cardRadius,
              ),
              alignment: Alignment.center,
              child: Icon(
                leadingIcon,
                color: appTheme.black,
                size: AppSizes.iconMd,
              ),
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Text(title, style: CustomTextStyles.bodyMediumBlack14_400),
            ),

            Icon(
              CupertinoIcons.chevron_right,
              color: appTheme.gray600,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
