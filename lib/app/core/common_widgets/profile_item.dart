import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:icons_plus/icons_plus.dart';

import '../values/colors.dart';
import '../values/s_image_strings.dart';
import '../values/s_spacing.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.onPress,
    required this.title,
    required this.icon,
    required this.color,
  });

  final VoidCallback onPress;
  final String title;
  final Widget? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade50,
      elevation: 0.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SvgPicture.asset(
              icon ?? SvgPicture.asset(SImageAssets.editAccount),
              //   height: 24,
              //   width: 24,
              //   color: Get.theme.colorScheme.outline,
              // ),
              SSpacing.mdW,
              Expanded(child: Text(title, style: Get.textTheme.bodyMedium)),
              // const Icon(
              //   FontAwesome.chevron_right_solid,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuItemTwo extends StatelessWidget {
  const ProfileMenuItemTwo({
    super.key,
    required this.onPress,
    required this.title,
    required this.icon,
    required this.color,
  });

  final VoidCallback onPress;
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: SColors.black),
              SSpacing.mdW,
              Expanded(child: Text(title, style: Get.textTheme.bodyMedium)),
              // const Icon(
              //   FontAwesome.chevron_right_solid,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
