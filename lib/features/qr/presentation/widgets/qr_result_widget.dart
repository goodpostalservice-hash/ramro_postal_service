import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/widgets/action_buttons.dart';

class QrResultWidget extends StatelessWidget {
  const QrResultWidget({
    super.key,
    required this.scannedCode,
    required this.scannedAddress,
    required this.isGettingAddress,
    required this.onShowInMap,
    required this.onScanAgain,
    required this.onSearchingTap,
  });

  final String scannedCode;
  final String? scannedAddress;
  final bool isGettingAddress;
  final VoidCallback? onShowInMap;
  final VoidCallback onScanAgain;
  final VoidCallback onSearchingTap;

  @override
  Widget build(BuildContext context) {
    final addressText = isGettingAddress
        ? 'Getting address...'
        : splitCoordinateString(scannedAddress ?? 'Address not found');

    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.iconsViewmapscan,
              height: AppSizes.logoLg + AppSpacing.xxl,
            ),
            AppSpacing.gapXxxl,
            Text(
              addressText,
              style: CustomTextStyles.bodyLargeblack500.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXl,
            if (scannedCode.isEmpty)
              PrimaryActionButton(
                width: AppSizes.logoLogin,
                height: AppSizes.buttonHeight,
                label: 'Searching ...',
                backgroundColor: appTheme.errorColor,
                onPressed: onSearchingTap,
                textStyle: CustomTextStyles.bodyLargeButton500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (scannedCode.isNotEmpty)
              PrimaryActionButton(
                width: AppSizes.logoLogin + AppSpacing.colossal,
                height: AppSizes.buttonHeight,
                label: 'Show in map',
                onPressed: isGettingAddress ? null : onShowInMap,
                textStyle: CustomTextStyles.bodyLargeButton500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            AppSpacing.gapMd,
            TextButton.icon(
              onPressed: onScanAgain,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
