import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';

import '../controller/home_driver_map_controller.dart';

Future<void> showAddressDetailsDialog(
  BuildContext context, {
  required String address,
  required Widget mapPreview, // pass your Static Map/Image here
  required VoidCallback onGetDirection,
  required LatLng destinationLocation,
  VoidCallback? onClose,
}) {
  final driverController = Get.find<HomeDriverMapController>();
  driverController.myDestinationName.value = address;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Address details',
    barrierColor: Colors.black.withOpacity(0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, __, ___) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return Transform.scale(
        scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved).value,
        child: Opacity(
          opacity: curved.value,
          child: _AddressDetailsCard(
            address: address,
            destinationLocation: destinationLocation,
            mapPreview: mapPreview,
            onGetDirection: onGetDirection,
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
    required this.mapPreview,
    required this.onGetDirection,
    required this.onClose,
    required this.destinationLocation,
  });

  final String address;
  final Widget mapPreview;
  final LatLng destinationLocation;
  final VoidCallback onGetDirection;
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        address,
                        style: CustomTextStyles.bodyLargeblack500,
                      ),
                    ),
                  ),

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

                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: AppButton(
                      label: 'Get direction',
                      onPressed: onGetDirection,
                      icon: SvgPicture.asset(Assets.navigation),
                    ),
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
