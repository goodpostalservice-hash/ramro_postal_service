import 'package:flutter/material.dart';

import '../constants/app_exports.dart';
import 'action_buttons.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppSpacing.mega,
              color: appTheme.errorColor,
            ),
            AppSpacing.gapMd,
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleMediumBlack18_500,
            ),
            if (message?.trim().isNotEmpty == true) ...[
              AppSpacing.gapSm,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: CustomTextStyles.bodyMediumGray600,
              ),
            ],
            if (onRetry != null) ...[
              AppSpacing.gapXl,
              PrimaryActionButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
