import 'package:flutter/material.dart';

import '../constants/app_exports.dart';
import 'action_buttons.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? getPadding(left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                height: getSize(72),
                width: getSize(72),
                decoration: BoxDecoration(
                  color: appTheme.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: getSize(34),
                  color: appTheme.orangeBase,
                ),
              ),
              SizedBox(height: getVerticalSize(20)),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleMediumBlack18_500.copyWith(
                color: appTheme.black900,
              ),
            ),
            if (message?.trim().isNotEmpty == true) ...[
              SizedBox(height: getVerticalSize(10)),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: CustomTextStyles.bodyMediumGray600.copyWith(height: 1.5),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: getVerticalSize(24)),
              PrimaryActionButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: Icons.refresh,
                // width: 124.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
