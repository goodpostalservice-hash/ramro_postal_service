import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../values/s_dimension.dart';

class CustomRow extends StatelessWidget {
  final String text1;
  final String text2;
  final Color? textColor;
  const CustomRow({
    super.key,
    required this.text1,
    required this.text2,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            text1,
            maxLines: 3,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: textColor ?? Color.fromRGBO(71, 84, 103, 1),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          text2,
          style: Get.textTheme.bodyMedium!.copyWith(
            color: textColor ?? Color.fromRGBO(71, 84, 103, 1),
          ),
        ),
      ],
    );
  }
}

class CustomRowWithIcons extends StatelessWidget {
  final String icons;
  final String text1;
  final String text2;
  final Color? color;
  const CustomRowWithIcons({
    super.key,
    required this.text1,
    required this.text2,
    required this.icons,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              icons,
              color: Get.theme.colorScheme.shadow,
              height: 16,
              width: 16,
            ),
            const SizedBox(width: 7),
            Text(
              text1,
              style: Get.textTheme.bodyMedium!.copyWith(
                color: Get.theme.colorScheme.shadow,
              ),
            ),
            // SmallTxt(
            //   text: text1,
            //   color: AppColors.textColors,
            //   size: Dimension.font18,
            // ),
          ],
        ),
        SizedBox(width: Dimension.height10),
        Text(text2, style: Get.textTheme.bodyMedium!.copyWith(color: color)),
      ],
    );
  }
}
