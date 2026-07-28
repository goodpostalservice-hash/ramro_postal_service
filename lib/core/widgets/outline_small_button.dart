import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

class OutlineSmallButton extends StatelessWidget {
  const OutlineSmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme.white,
      borderRadius: AppRadius.buttonRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.buttonRadius,
        child: Container(
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.sm + AppSpacing.xxs,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.buttonRadius,
            border: Border.all(color: appTheme.orange0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.iconSm, color: appTheme.orange200),
              AppSpacing.horizontalGapXs,
              Text(
                label,
                style: CustomTextStyles.bodySmallOrange12_400.copyWith(
                  color: appTheme.orange200,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
