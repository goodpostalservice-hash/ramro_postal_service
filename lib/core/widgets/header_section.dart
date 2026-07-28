import 'package:flutter/material.dart';

import '../constants/app_exports.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: getHorizontalSize(12)),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text(
                title,
                style:
                    titleStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF111111),
                      fontSize: getFontSize(22),
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (subtitle?.trim().isNotEmpty == true) ...[
                SizedBox(height: getVerticalSize(4)),
                Text(
                  subtitle!,
                  style:
                      subtitleStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF888888),
                        fontSize: getFontSize(13),
                      ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: getHorizontalSize(12)),
          trailing!,
        ],
      ],
    );

    if (padding == null) return content;

    return Padding(padding: padding!, child: content);
  }
}
