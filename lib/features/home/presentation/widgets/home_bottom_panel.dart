import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/home/presentation/controllers/home_controller.dart';

import '../../../dashboard/presentation/widgets/save_address_dialog.dart';
import '../controllers/naviagtion_controller.dart';
import 'generate_qr_dialog.dart';

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    super.key,
    required this.addressTitle,
    required this.addressSubtitle,
    required this.onNavigate,
    required this.onSave,
    required this.onShare,
    required this.onClose,
    this.onSizeChanged,
  });

  final String addressTitle;
  final String addressSubtitle;
  final VoidCallback onNavigate;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onClose;
  final ValueChanged<Size>? onSizeChanged;

  @override
  State<BottomPanel> createState() => BottomPanelState();
}

class BottomPanelState extends State<BottomPanel> {
  int buttonIndex = 0;
  final driverController = Get.find<HomeController>();

  Widget _svgIcon(String asset, int index) {
    return SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(
        buttonIndex == index ? appTheme.gray25 : appTheme.orange200,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _MeasureSize(
          onChange: widget.onSizeChanged,
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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      AppButton(
                        label: 'Navigate',
                        onPressed: () async {
                          setState(() {
                            buttonIndex = 0;
                          });

                          final hasCurrentLocation = await driverController
                              .getFreshLocation();
                          if (!hasCurrentLocation) {
                            Get.snackbar(
                              'Location unavailable',
                              'Enable location services and grant permission to navigate.',
                            );
                            return;
                          }

                          final mapboxNavigationController = Get.put(
                            MapboxNavigationController(),
                          );

                          // await mapboxNavigationController.startNavigation(
                          //   originLat: driverController
                          //       .myCurrentLocation
                          //       .value
                          //       .latitude,
                          //   originLng: driverController
                          //       .myCurrentLocation
                          //       .value
                          //       .longitude,
                          //   destinationLat: driverController
                          //       .destinationCoordinates
                          //       .value
                          //       .latitude,
                          //   destinationLng: driverController
                          //       .destinationCoordinates
                          //       .value
                          //       .longitude,
                          //   simulateRoute: false,
                          // );
                          print(
                            "######################################################",
                          );
                          print(driverController.myCurrentLocation.value);
                          print(driverController.destinationCoordinates);
                        },
                        loadingText: '',
                        variant: buttonIndex == 0
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlined,
                        icon: _svgIcon(Assets.navigation, 0),
                      ),

                      AppSpacing.horizontalGapSm,
                      AppButton(
                        label: 'Save',
                        onPressed: () async {
                          setState(() {
                            buttonIndex = 3;
                          });

                          await showSaveAddressDialog(
                            context,
                            widget.addressTitle,
                            "${driverController.destinationCoordinates.value.latitude},${driverController.destinationCoordinates.value.longitude}",
                          );
                        },
                        loadingText: '',
                        icon: Icon(
                          Icons.bookmark_rounded,
                          color: buttonIndex == 3
                              ? appTheme.gray25
                              : appTheme.orange200,
                        ),
                        variant: buttonIndex == 3
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlined,
                      ),

                      AppSpacing.horizontalGapSm,
                      AppButton(
                        label: 'Generate QR',
                        onPressed: () async {
                          setState(() {
                            buttonIndex = 1;
                          });

                          final destination =
                              driverController.destinationCoordinates.value;

                          await generateQRDialog(
                            context: context,
                            fullAddress: widget.addressTitle,
                            destinationLatitude: destination.latitude
                                .toString(),
                            destinationLongitude: destination.longitude
                                .toString(),
                          );
                        },
                        icon: _svgIcon(Assets.plus, 1),
                        variant: buttonIndex == 1
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlined,
                      ),

                      AppSpacing.horizontalGapSm,

                      AppButton(
                        label: 'Share',
                        onPressed: () {
                          setState(() {
                            buttonIndex = 2;
                          });

                          widget.onShare();
                        },
                        loadingText: '',
                        icon: _svgIcon(Assets.share, 2),
                        variant: buttonIndex == 2
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size>? onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  _MeasureSizeRenderObject(this.onChange);

  ValueChanged<Size>? onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize) {
      return;
    }

    _oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange?.call(newSize);
    });
  }
}
