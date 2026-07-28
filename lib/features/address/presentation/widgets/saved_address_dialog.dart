import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/common/data/models/location_name_request.dart';

import '../../../common/presentation/controllers/common_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../controllers/address_controller.dart';

Future<void> showSavedAddressDetailsDialog(
  BuildContext context, {
  String? address,
  required LatLng destinationLocation,
  required VoidCallback onDelete,
  required VoidCallback onShare,
  VoidCallback? onClose,
}) {
  final driverController = Get.find<HomeController>();
  final locationNameController = Get.find<CommonController>();
  final hasAddress = address != null && address.trim().isNotEmpty;

  if (hasAddress) {
    driverController.setDestination(
      coordinates: destinationLocation,
      name: splitCoordinateString(address),
    );
  } else {
    driverController.setDestination(coordinates: destinationLocation, name: '');
    final request = LocationNameRequest(
      latitude: destinationLocation.latitude.toString(),
      longitude: destinationLocation.longitude.toString(),
    );
    locationNameController.getLocationName(request);
  }

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Address details',
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, __, ___) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return Transform.scale(
        scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved).value,
        child: Opacity(
          opacity: curved.value,
          child: _AddressDetailsCard(
            address: hasAddress ? address : '',
            destinationLocation: destinationLocation,
            onDelete: onDelete,
            onShare: onShare,
            onClose: onClose ?? () => Navigator.of(ctx).pop(),
          ),
        ),
      );
    },
  );
}

class _AddressDetailsCard extends StatelessWidget {
  const _AddressDetailsCard({
    required this.address,
    required this.onDelete,
    required this.onShare,
    required this.onClose,
    required this.destinationLocation,
  });

  final String address;
  final LatLng destinationLocation;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onClose;

  Color get _bg => appTheme.gray25;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: Offset(0, 10),
                    color: Color(0x1A000000), // subtle shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header: icon + title + close
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.place,
                          size: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Address details',
                          style: CustomTextStyles.bodySmallGray12_400,
                        ),
                      ),
                      InkWell(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _bg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Address text
                  Obx(() {
                    final value =
                        Get.find<HomeController>().myDestinationName.value;

                    if (value.trim().isEmpty) {
                      return Container(
                        height: 24.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appTheme.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: CustomTextStyles.bodyLargeblack500,
                      ),
                    );
                  }),
                  const SizedBox(height: 8.0),
                  // Map preview (rounded)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 10, // similar proportion as screenshot
                      child: GoogleMap(
                        liteModeEnabled: true,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        initialCameraPosition: CameraPosition(
                          zoom: 17.0,
                          target: LatLng(
                            destinationLocation.latitude,
                            destinationLocation.longitude,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => AppButton(
                            label: 'Delete',
                            isLoading:
                                Get.find<AddressController>().isDeleting.value,
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline),
                            variant: AppButtonVariant.outlined,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'Share',
                          onPressed: onShare,
                          icon: const Icon(Icons.share_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
