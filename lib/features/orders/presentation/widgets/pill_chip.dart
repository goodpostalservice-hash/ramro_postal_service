import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

enum PillType { success, warning, danger, info }

class Pill extends StatelessWidget {
  const Pill({super.key, required this.text, required this.type});

  final String text;
  final PillType type;

  @override
  Widget build(BuildContext context) {
    final colors = _pillColors(type);
    return Container(
      padding: getPadding(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(getHorizontalSize(999)),
      ),
      child: Text(
        text.isNotEmpty ? text : '—',
        style: CustomTextStyles.bodySmallGray12_400.copyWith(
          color: colors.$2,
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(12),
        ),
      ),
    );
  }

  (Color, Color) _pillColors(PillType t) {
    switch (t) {
      case PillType.success:
        return (Colors.green.withOpacity(.12), Colors.green.shade800);
      case PillType.warning:
        return (appTheme.orange50, Colors.orange.shade800);
      case PillType.danger:
        return (Colors.red.withOpacity(.12), Colors.red.shade800);
      case PillType.info:
        return (Colors.blue.withOpacity(.10), Colors.blue.shade800);
    }
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(left: 10, right: 10, top: 8, bottom: 8),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: getSize(18), color: appTheme.gray700),
          SizedBox(width: getHorizontalSize(6)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: CustomTextStyles.bodySmallGray12_400.copyWith(
                  color: appTheme.gray600,
                  fontSize: getFontSize(11),
                ),
              ),
              Text(
                value,
                style: CustomTextStyles.bodySmallGray800_12_400.copyWith(
                  color: appTheme.gray800,
                  fontSize: getFontSize(13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
