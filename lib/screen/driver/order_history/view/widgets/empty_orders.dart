import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

class EmptyOrdersState extends StatelessWidget {
  const EmptyOrdersState({super.key, required this.onRefresh});
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: getPadding(all: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: getSize(64),
              width: getSize(64),
              decoration: AppDecoration.fillPrimary.copyWith(
                borderRadius: BorderRadiusStyle.circleBorder19,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.white,
              ),
            ),
            SizedBox(height: getVerticalSize(12)),
            Text(
              "No orders yet",
              style: CustomTextStyles.titleMediumBlack18_500.copyWith(
                fontSize: getFontSize(20),
              ),
            ),
            SizedBox(height: getVerticalSize(6)),
            Text(
              "Your order history will appear here once you start shipping.",
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMediumBlack1000_14_500.copyWith(
                color: appTheme.gray600,
                fontSize: getFontSize(14),
              ),
            ),
            SizedBox(height: getVerticalSize(14)),
            AppButton(
              borderRadius: getHorizontalSize(12),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: 'Refresh',
              onPressed: () async => onRefresh(),
            ),
          ],
        ),
      ),
    );
  }
}
