import 'package:flutter/material.dart';

import '../constants/app_export.dart';

enum AppButtonVariant { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.icon,
    this.minHeight = 52,
    this.borderRadius = 8,
    this.loadingText,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final String? loadingText;
  final Widget? icon;
  final double minHeight;
  final double borderRadius;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final bgFilled = appTheme.orangeBase;
    final border = appTheme.orange0;
    final textFilled = appTheme.gray25;
    final textOutlined = appTheme.orangeBase;

    final ButtonStyle baseOutlined = OutlinedButton.styleFrom(
      minimumSize: Size.fromHeight(minHeight),
      side: BorderSide(color: border, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      backgroundColor: Colors.white,
      foregroundColor: textOutlined,
      disabledForegroundColor: appTheme.orangeBase,
    );

    final ButtonStyle baseFilled = ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(minHeight),
      elevation: 0,
      backgroundColor: _isEnabled ? bgFilled : appTheme.gray100,
      foregroundColor: textFilled,
      disabledBackgroundColor: appTheme.gray400,
      disabledForegroundColor: appTheme.orangeBase,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    final child = _ButtonChild(
      label: label,
      isLoading: isLoading,
      loadingText: loadingText,
      icon: icon,
      varient: variant,
      textStyle: CustomTextStyles.bodyLargeButton500,
    );

    if (variant == AppButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: _isEnabled ? onPressed : null,
        style: baseOutlined,
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: _isEnabled ? onPressed : null,
      style: baseFilled,
      child: child,
    );
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({
    required this.label,
    required this.isLoading,
    this.loadingText,
    required this.textStyle,
    this.icon,
    required this.varient,
  });

  final String label;
  final bool isLoading;
  final String? loadingText;
  final TextStyle textStyle;
  final Widget? icon;
  final AppButtonVariant varient;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Text(loadingText!, style: CustomTextStyles.bodyLargeButton500);
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 10),
          Text(
            label,
            style: varient == AppButtonVariant.filled
                ? CustomTextStyles.bodyLargeButton500
                : CustomTextStyles.bodyLargeButton500Orange,
          ),
        ],
      );
    }
    return Text(
      label,
      style: varient == AppButtonVariant.filled
          ? CustomTextStyles.bodyLargeButton500
          : CustomTextStyles.bodyLargeButton500Orange,
    );
  }
}
