import 'package:flutter/material.dart';

import '../constants/app_exports.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.children,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: children,
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = AppSizes.buttonHeight,
    this.borderRadius = AppRadius.button,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? appTheme.orangeBase,
          foregroundColor: foregroundColor ?? appTheme.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconMd),
              AppSpacing.horizontalGapSm,
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle ??
                    TextStyle(
                      color: foregroundColor ?? appTheme.white,
                      fontSize: AppTheme.light.textTheme.bodyMedium?.fontSize,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
