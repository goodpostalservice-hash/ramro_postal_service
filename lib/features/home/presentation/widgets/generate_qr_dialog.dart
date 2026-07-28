import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

import '../../../qr/data/models/generate_qr_request.dart';
import '../../../qr/presentation/controllers/qr_controller.dart';

Future<bool?> generateQRDialog({
  required BuildContext context,
  required String fullAddress,
  required String destinationLatitude,
  required String destinationLongitude,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _GenerateQRDialog(
      fullAddress: fullAddress,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
    ),
  );
}

class _GenerateQRDialog extends StatefulWidget {
  const _GenerateQRDialog({
    required this.fullAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  final String fullAddress;
  final String destinationLatitude;
  final String destinationLongitude;

  @override
  State<_GenerateQRDialog> createState() => _GenerateQRDialogState();
}

class _GenerateQRDialogState extends State<_GenerateQRDialog> {
  final _labelController = TextEditingController();
  bool _setAsHome = false;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _onHomeChanged(bool value) {
    setState(() {
      _setAsHome = value;
      _labelController.text = value ? 'Home' : '';
    });
  }

  String get _selectedLabel =>
      _setAsHome ? 'Home' : _labelController.text.trim();

  final addressController = Get.find<QrController>();

  Future<void> _generateQr() async {
    final request = GenerateQrRequest(
      destinationLatitude: widget.destinationLatitude,
      destinationLognitude: widget.destinationLongitude,
      isStaticRoute: 0,
      userType: 'user',
      auth: '1',
      label: _selectedLabel,
      fullAddress: widget.fullAddress,
    );

    await addressController.generateqr(request);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate QR'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Full Address'),
          AppSpacing.gapSm,
          Container(
            width: double.infinity,
            padding: AppSpacing.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: appTheme.gray25,
              border: Border.all(color: appTheme.gray200),
              borderRadius: AppRadius.textFieldRadius,
            ),
            child: Text(
              widget.fullAddress,
              style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                height: 1.35,
              ),
            ),
          ),
          AppSpacing.gapLg,
          _sectionLabel('Label'),
          CustomTextFormField(
            controller: _labelController,
            hint: 'Example: Office, Shop',
            isReadOnly: _setAsHome,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            value: _setAsHome,
            title: const Text('Set as home'),
            onChanged: (value) => _onHomeChanged(value ?? false),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.outlined,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            AppSpacing.horizontalGapMd,
            Obx(
              () => Expanded(
                child: AppButton(
                  label: 'Generate',
                  isLoading: addressController.isBottomPanelLoading.value,
                  loadingText: 'Generating',
                  icon: addressController.isBottomPanelLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: appTheme.orangeBase,
                          ),
                        )
                      : null,
                  onPressed: _generateQr,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
