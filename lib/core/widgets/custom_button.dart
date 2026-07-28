import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

enum AppButtonVariant { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.isEnabled = true, // ✅ Explicit enable/disable option
    this.icon,
    this.borderRadius = 8,
    this.loadingText,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isEnabled;
  final String? loadingText;
  final Widget? icon;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? height;

  // Button is only active if isEnabled is true, it's not loading, and onPressed exists
  bool get _isEffectivelyEnabled =>
      isEnabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    final child = _ButtonChild(
      label: label,
      isEffectivelyEnabled: _isEffectivelyEnabled,
      isLoading: isLoading,
      loadingText: loadingText,
      icon: icon,
      variant: variant,
    );

    // Common styles applied to both button types
    final commonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStateProperty.all(shape),
      alignment: Alignment.center,
    );

    final Widget button;

    if (variant == AppButtonVariant.outlined) {
      button = OutlinedButton(
        onPressed: _isEffectivelyEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _isEffectivelyEnabled
              ? appTheme.orangeBase
              : appTheme.gray400,
          side: BorderSide(
            color: _isEffectivelyEnabled ? appTheme.orange0 : appTheme.gray200,
            width: 1,
          ),
        ).merge(commonStyle),
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: _isEffectivelyEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _isEffectivelyEnabled
              ? appTheme.orangeBase
              : appTheme.gray500,
          foregroundColor: appTheme.gray25,
          disabledBackgroundColor: appTheme.gray200,
          disabledForegroundColor: appTheme.gray400,
        ).merge(commonStyle),
        child: child,
      );
    }

    // Prevents taps during loading or disabled state
    return AbsorbPointer(
      absorbing: !_isEffectivelyEnabled,
      child: height == null ? button : SizedBox(height: height, child: button),
    );
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({
    required this.label,
    required this.isEffectivelyEnabled,
    required this.isLoading,
    required this.variant,
    this.loadingText,
    this.icon,
  });

  final String label;
  final bool isEffectivelyEnabled;
  final bool isLoading;
  final String? loadingText;
  final Widget? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle;

    if (!isEffectivelyEnabled) {
      textStyle = CustomTextStyles.bodyLargeButton500.copyWith(
        color: appTheme.gray700,
      );
    } else if (variant == AppButtonVariant.filled) {
      textStyle = CustomTextStyles.bodyLargeButton500;
    } else {
      textStyle = CustomTextStyles.bodyLargeButton500Orange;
    }

    // Loading State: Show Spinner + Optional Text
    if (isLoading) {
      final Color spinnerColor = variant == AppButtonVariant.filled
          ? appTheme.gray25
          : appTheme.orangeBase;

      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
              ),
            ),
            if (loadingText != null && loadingText!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(loadingText!, textAlign: TextAlign.center, style: textStyle),
            ],
          ],
        ),
      );
    }

    // Normal State with Icon
    if (icon != null) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            const SizedBox(width: 9),
            Flexible(
              child: Text(label, textAlign: TextAlign.center, style: textStyle),
            ),
          ],
        ),
      );
    }

    // Normal State without Icon
    return Center(
      child: Text(label, textAlign: TextAlign.center, style: textStyle),
    );
  }
}
