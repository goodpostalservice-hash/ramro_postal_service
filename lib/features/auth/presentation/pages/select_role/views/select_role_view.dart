import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/storage/storage_util.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';

import '../../../../../../core/models/user_model.dart';
import '../controllers/select_role_controller.dart';

class SelectRoleView extends GetView<SelectRoleController> {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Scaffold(
      backgroundColor: appTheme.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            children: [
              AppSpacing.gapLg,

              const Spacer(),

              _AppLogo(),

              AppSpacing.gapXxxl,

              Text(
                'Welcome!',
                style: t.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              AppSpacing.gapSm,

              Text(
                'Choose how you want to continue',
                textAlign: TextAlign.center,
                style: t.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.colossal),

              Obx(
                () => RoleCard(
                  icon: Icons.local_taxi,
                  title: 'Driver',
                  description: 'Earn money by giving rides',
                  isSelected: controller.selectedRole.value == 'driver',
                  onTap: () {
                    controller.selectedRole.value = 'driver';
                  },
                ),
              ),

              AppSpacing.gapLg,

              Obx(
                () => RoleCard(
                  icon: Icons.person,
                  title: 'User',
                  description: 'Request rides to your destination',
                  isSelected: controller.selectedRole.value == 'user',
                  onTap: () {
                    controller.selectedRole.value = 'user';
                  },
                ),
              ),

              AppSpacing.gapXxxl,

              Obx(
                () => AppButton(
                  onPressed: controller.selectedRole.value == null
                      ? null
                      : () async {
                          await SStorageUtil.saveUserData(
                            userData: UserData(
                              userType: controller.selectedRole.value,
                            ),
                          );
                          print("********************");
                          print(SStorageUtil.getUserData()?.userType);
                          Get.toNamed(AppRoutes.login);
                        },
                  label: 'Continue',
                  // radius is handled by your button styles; if your AppButton supports it, you can set.
                ),
              ),

              const Spacer(),

              Padding(
                padding: AppSpacing.only(bottom: AppSpacing.md),
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.iconsSmallLogo,
      width: AppSizes.logoLg,
      height: AppSizes.logoLg,
      fit: BoxFit.contain,
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    final bg = isSelected ? cs.primary : cs.surface;
    final border = isSelected ? cs.primary : cs.outlineVariant;
    final titleColor = isSelected ? cs.onPrimary : cs.onSurface;
    final descColor = isSelected
        ? cs.onPrimary.withOpacity(0.9)
        : cs.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: AppSpacing.all(AppSpacing.lg + AppSpacing.xxs),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: border, width: AppSizes.dividerThickness),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cs.primary.withOpacity(0.22)
                  : appTheme.black.withOpacity(0.04),
              blurRadius: AppSpacing.md + AppSpacing.xxs,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.avatarLg,
              height: AppSizes.avatarLg,
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.onPrimary.withOpacity(0.18)
                    : cs.primary.withOpacity(0.08),
                borderRadius: AppRadius.cardRadius,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconXl,
                color: isSelected ? cs.onPrimary : cs.primary,
              ),
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    description,
                    style: t.textTheme.bodyMedium?.copyWith(color: descColor),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: cs.onPrimary,
                size: AppSizes.iconXl - AppSpacing.xs,
              ),
          ],
        ),
      ),
    );
  }
}
