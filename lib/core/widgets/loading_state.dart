import 'package:flutter/material.dart';

import '../constants/app_exports.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.message,
    this.size = 26,
    this.strokeWidth = 2.4,
  });

  final String? message;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: getSize(size),
            height: getSize(size),
            child: CircularProgressIndicator(
              strokeWidth: getHorizontalSize(strokeWidth),
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.orangeBase),
            ),
          ),
          if (message?.trim().isNotEmpty == true) ...[
            SizedBox(height: getVerticalSize(12)),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMediumGray600,
            ),
          ],
        ],
      ),
    );
  }
}
