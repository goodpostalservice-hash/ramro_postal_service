import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/s_image_strings.dart';
import '../values/s_spacing.dart';
import 'preview_card_image.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SSpacing.colossalH,
          const PreviewCardImage(
            url: '',
            errorImage: AssetImage(SImageAssets.noItem),
            height: 100,
            width: 200,
          ),
          SSpacing.xxxlH,
          Text(
            message ?? 'Empty Item',
            maxLines: 2,
            style: Get.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
