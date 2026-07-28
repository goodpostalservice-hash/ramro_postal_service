import 'package:flutter/material.dart';

import '../constants/app_exports.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius = AppRadius.card,
    this.border,
    this.boxShadow,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? appTheme.white,
        borderRadius: AppRadius.circular(borderRadius),
        border: border,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: appTheme.black.withValues(alpha: 0.06),
                blurRadius: AppSpacing.xl,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: child,
    );
  }
}
