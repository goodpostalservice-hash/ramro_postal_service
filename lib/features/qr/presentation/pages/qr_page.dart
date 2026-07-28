import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/widgets/custom_app_widget.dart';
import 'package:ramro_postal_service/features/qr/data/models/delete_qr_request.dart';

import '../../../search/presentation/bindings/show_search_on_map_binding.dart';
import '../../../search/presentation/pages/show_search_on_map_screen.dart';
import '../controllers/qr_controller.dart';

class MyQRScreen extends StatefulWidget {
  const MyQRScreen({super.key});

  @override
  State<MyQRScreen> createState() => _MyQRScreenState();
}

class _MyQRScreenState extends State<MyQRScreen> {
  final QrController controller = Get.find<QrController>();

  /// Tracks the ID of the QR currently being deleted, so only its
  /// delete button shows a spinner instead of all of them.
  final Rxn<dynamic> _deletingId = Rxn<dynamic>();

  static const String _kBaseUrl = 'https://ramropostalservice.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: backAppBar("Generated QR".toUpperCase(), context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.qrList.isEmpty) {
          return const Center(child: Text("No QR Codes Found"));
        }
        return Padding(
          padding: const EdgeInsets.all(7),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.qrList.length,
            itemBuilder: (_, index) => _buildQrItem(controller.qrList[index]),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // QR LIST ITEM
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildQrItem(dynamic item) {
    final label = item.label?.trim() as String?;
    final fullAddress = item.fullAddress?.trim() as String?;
    final hasLabel = label != null && label.isNotEmpty;
    final hasFullAddress = fullAddress != null && fullAddress.isNotEmpty;
    final qrUrl = '$_kBaseUrl${item.qrcodePath}';

    return InkWell(
      onTap: () => _showQrPreview(
        item: item,
        label: label,
        fullAddress: fullAddress,
        hasLabel: hasLabel,
        hasFullAddress: hasFullAddress,
        qrUrl: qrUrl,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appTheme.gray25,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appTheme.gray200),
        ),
        child: Row(
          children: [
            /// QR thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.network(
                qrUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                placeholderBuilder: (_) => const SizedBox(
                  height: 60,
                  width: 60,
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.qr_code, size: 40),
              ),
            ),
            const SizedBox(width: 12),

            /// Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasLabel ? label : 'QR Code',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodyMediumBlack_14_500,
                  ),
                  if (hasFullAddress) ...[
                    const SizedBox(height: 4),
                    Text(
                      fullAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodySmallGray800_12_400,
                    ),
                  ],
                ],
              ),
            ),

            /// ACTION (Delete Button)
            Obx(() {
              // Check if THIS specific item is currently being deleted
              final isDeletingThis = _deletingId.value == item.id;

              return IconButton(
                tooltip: 'Delete QR Code',
                icon: isDeletingThis
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors
                              .red, // Makes the spinner visible and matches the delete color
                        ),
                      )
                    : const Icon(Icons.delete, color: Colors.red),
                // Disable button if this item is deleting, otherwise trigger confirmation
                onPressed: isDeletingThis
                    ? null
                    : () => _confirmDelete(
                        itemId: item.id,
                        label: hasLabel ? label : '',
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete({
    required dynamic itemId,
    required String label,
  }) async {
    if (itemId == null) return;

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete QR Code?'),
        content: Text(
          label.isEmpty
              ? 'Are you sure you want to delete this QR Code? This action cannot be undone.'
              : 'Are you sure you want to delete "$label"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    // If user cancelled, do nothing
    if (confirmed != true) return;

    // Set the deleting ID for this specific item (Triggers the Obx to show spinner)
    _deletingId.value = itemId;

    try {
      // Await the actual deletion from the controller
      await controller.deleteQr(DeleteQrRequest(qrcode_id: itemId));
    } finally {
      // Clear the spinner state
      if (_deletingId.value == itemId) {
        _deletingId.value = null;
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  // QR PREVIEW DIALOG
  // ─────────────────────────────────────────────────────────────────────
  void _showQrPreview({
    required dynamic item,
    required String? label,
    required String? fullAddress,
    required bool hasLabel,
    required bool hasFullAddress,
    required String qrUrl,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: getPadding(left: 16, right: 16, top: 12, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "QR Preview",
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.titleMediumBlack18_500,
                    ),
                  ),
                  InkWell(
                    onTap: Get.back,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: getPadding(all: 6),
                      child: Icon(
                        Icons.close,
                        size: getSize(22),
                        color: appTheme.black900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(16)),

              // Label & address (if present)
              if (hasLabel || hasFullAddress) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasLabel)
                        Text(
                          label!,
                          style: CustomTextStyles.bodyMediumBlack_14_500,
                        ),
                      if (hasFullAddress) ...[
                        if (hasLabel) const SizedBox(height: 4),
                        Text(
                          fullAddress!,
                          style: CustomTextStyles.bodySmallGray800_12_400,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: getVerticalSize(16)),
              ],

              // QR image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.network(
                  qrUrl,
                  height: getSize(200),
                  width: getSize(200),
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => SizedBox(
                    height: getSize(200),
                    width: getSize(200),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.qr_code,
                    size: getSize(100),
                    color: appTheme.gray600,
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(16)),

              // Actions
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    AppButton(
                      label: "Show in Map",
                      variant: AppButtonVariant.outlined,
                      icon: Icon(Icons.map_outlined, size: getSize(18)),
                      onPressed: () => _openMap(item, fullAddress, label),
                    ),
                    SizedBox(width: getHorizontalSize(12)),
                    AppButton(
                      label: "Share",
                      variant: AppButtonVariant.filled,
                      icon: Icon(
                        Icons.ios_share_rounded,
                        size: getSize(18),
                        color: appTheme.orangeBase,
                      ),
                      onPressed: () async {
                        Get.back();
                        // TODO: Implement share functionality
                        // await shareQrSvgAsStyledPng(
                        //   svgUrl: qrUrl,
                        //   caption: "Scan to view the address",
                        //   logoAssetPath: "assets/icons/logo.png",
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // OPEN MAP
  // ─────────────────────────────────────────────────────────────────────
  void _openMap(dynamic item, String? fullAddress, String? label) {
    Get.back();

    final latitude = double.tryParse(item.destinationLatitude ?? '');
    final longitude = double.tryParse(item.destinationLongitude ?? '');

    if (latitude == null || longitude == null) {
      Get.snackbar('Error', 'QR location data is missing');
      return;
    }

    Get.to(
      () => ShowSearchOnMapScreen(
        latitude: latitude,
        longitude: longitude,
        address: fullAddress ?? label ?? 'QR Location',
        houseno: '',
        street: '',
        zone: '',
        sub: '',
        locationName: label ?? '',
      ),
      binding: ShowSearchOnMapBinding(),
    );
  }
}
