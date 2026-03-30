import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

enum PillType { success, warning, danger, info }

class Pill extends StatelessWidget {
  const Pill({super.key, required this.text, required this.type});

  final String text;
  final PillType type;

  @override
  Widget build(BuildContext context) {
    Color bg;

    switch (type) {
      case PillType.success:
        bg = Colors.green.withOpacity(.12);
        break;
      case PillType.warning:
        bg = appTheme.orange50;
        break;
      case PillType.danger:
        bg = Colors.red.withOpacity(.12);
        break;
      case PillType.info:
        bg = Colors.blue.withOpacity(.10);
        break;
    }

    return Container(
      padding: getPadding(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(getHorizontalSize(999)),
      ),
      child: Text(
        text.isNotEmpty ? text : "—",
        style: CustomTextStyles.bodySmallGray12_400.copyWith(
          color: appTheme.white,
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(12),
        ),
      ),
    );
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
