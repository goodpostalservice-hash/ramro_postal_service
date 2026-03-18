import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/common/navigation/navigation_screen.dart';

import '../controller/home_driver_map_controller.dart';

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    super.key,
    required this.addressTitle,
    required this.addressSubtitle,
    required this.onNavigate,
    required this.onSave,
    required this.onShare,
    required this.onClose,
  });

  final String addressTitle;
  final String addressSubtitle;
  final VoidCallback onNavigate;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onClose;

  @override
  State<BottomPanel> createState() => BottomPanelState();
}

class BottomPanelState extends State<BottomPanel> {
  int buttonIndex = 0;
  final driverController = Get.find<HomeDriverMapController>();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 30,
              offset: Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // grabber
                Container(
                  width: 56,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: appTheme.gray50,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 120.0),
                InkWell(
                  onTap: widget.onClose,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: appTheme.gray200,
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
            SizedBox(height: 15.0),
            // address card inside
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: appTheme.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.addressTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumBlack18_500,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.addressSubtitle,
                    style: CustomTextStyles.bodySmallGray800_12_400,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                // Navigate (filled)
                Expanded(
                  child: AppButton(
                    label: 'Navigate',
                    onPressed: () {
                      setState(() {
                        buttonIndex = 0;
                      });

                      Get.to(
                        () => NavigationScreen(),
                        arguments: {
                          'origin': driverController.myCurrentLocation.value,
                          'destination':
                              driverController.destinationCoordinates.value,
                        },
                      );
                    },
                    loadingText: '',
                    variant: buttonIndex == 0
                        ? AppButtonVariant.filled
                        : AppButtonVariant.outlined,
                    icon: SvgPicture.asset(
                      Assets.navigation,
                      color: buttonIndex == 0
                          ? appTheme.gray25
                          : appTheme.orange200,
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: AppButton(
                    label: 'Save',
                    onPressed: () {
                      setState(() {
                        buttonIndex = 1;
                      });
                      showSaveAddressDialog(
                        context,
                        latLng: LatLng(27.675859, 85.351339),
                        destinationAddress: widget.addressTitle,
                      );
                    },
                    loadingText: '',
                    icon: SvgPicture.asset(
                      Assets.plus,
                      color: buttonIndex == 1
                          ? appTheme.gray25
                          : appTheme.orange200,
                    ),
                    variant: buttonIndex == 1
                        ? AppButtonVariant.filled
                        : AppButtonVariant.outlined,
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: AppButton(
                    label: 'Share',
                    onPressed: () {
                      setState(() {
                        buttonIndex = 2;
                      });

                      print("save");
                    },
                    loadingText: '',
                    icon: SvgPicture.asset(
                      Assets.share,
                      color: buttonIndex == 2
                          ? appTheme.gray25
                          : appTheme.orange200,
                    ),
                    variant: buttonIndex == 2
                        ? AppButtonVariant.filled
                        : AppButtonVariant.outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
