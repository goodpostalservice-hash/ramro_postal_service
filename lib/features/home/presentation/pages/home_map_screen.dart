import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/address_split.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/features/home/presentation/controllers/home_controller.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../widgets/home_bottom_panel.dart';
import '../widgets/home_tutorial.dart';
import '../widgets/map_type_setting.dart';
import '../widgets/search_bar.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});
  static LatLng? currentLocationAtStart;

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _mapController;

  // Map configuration
  static const double _defaultZoom = 17.0;
  static const double _minZoom = 10.0;
  static const double _maxZoom = 21.0;
  static const double _defaultControlsBottom = 180.0;
  static const String _tutorialCompletedKey = 'home_map_tutorial_completed_v2';
  static const int _tutorialStepCount = 3;
  MapType _selectedMapType = MapType.normal;
  Size _topOverlaySize = Size.zero;
  Size _bottomOverlaySize = Size.zero;
  Timer? _tutorialTimer;
  bool _isTutorialShowing = false;

  // Controllers

  final controller = Get.find<HomeController>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tutorialTimer = Timer(const Duration(milliseconds: 500), _showTutorial);
    });
  }

  @override
  void dispose() {
    _tutorialTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _showTutorial() async {
    if (!mounted || _isTutorialShowing) return;
    _isTutorialShowing = true;

    final preferences = await SharedPreferences.getInstance();
    if (!mounted || preferences.getBool(_tutorialCompletedKey) == true) {
      _isTutorialShowing = false;
      return;
    }

    final tutorial = TutorialCoachMark(
      targets: _createTutorialTargets(),
      colorShadow: const Color(0xFF0D1B2A),
      textSkip: 'SKIP',
      textStyleSkip: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        letterSpacing: 1.2,
      ),
      paddingFocus: 12,
      opacityShadow: 0.92,
      onFinish: _completeTutorial,
      onSkip: () {
        unawaited(_completeTutorial());
        return true;
      },
    );

    tutorial.show(context: context);
  }

  Future<void> _completeTutorial() async {
    _isTutorialShowing = false;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_tutorialCompletedKey, true);
  }

  List<TargetFocus> _createTutorialTargets() {
    final screenSize = MediaQuery.sizeOf(context);

    return [
      _tutorialTarget(
        identify: 'welcome',
        position: _mapGestureTarget(screenSize, verticalFactor: 0.18),
        alignment: ContentAlign.bottom,
        icon: Icons.map_rounded,
        color: const Color(0xFF1976D2),
        title: 'Welcome to\nRamro Postal Service',
        description: 'Discover addresses and navigate with three quick tips.',
        step: 1,
        buttonText: 'Get Started',
      ),
      _tutorialTarget(
        identify: 'long_press',
        position: _mapGestureTarget(screenSize, verticalFactor: 0.22),
        alignment: ContentAlign.bottom,
        icon: Icons.touch_app_rounded,
        color: const Color(0xFFE65100),
        title: 'Long Press\nfor Address',
        description:
            'Press and hold anywhere on the map to view that location\'s address.',
        step: 2,
        buttonText: 'Got it',
      ),
      _tutorialTarget(
        identify: 'zoom',
        position: _mapGestureTarget(screenSize, verticalFactor: 0.72),
        alignment: ContentAlign.top,
        icon: Icons.zoom_in_rounded,
        color: const Color(0xFF2E7D32),
        title: 'Zoom In for\nHouse Numbers',
        description:
            'Pinch the map to zoom in and reveal individual house numbers.',
        step: 3,
        buttonText: 'Start Exploring',
      ),
    ];
  }

  TargetPosition _mapGestureTarget(
    Size screenSize, {
    required double verticalFactor,
  }) {
    return TargetPosition(
      const Size(1, 1),
      Offset(screenSize.width / 2, screenSize.height * verticalFactor),
    );
  }

  TargetFocus _tutorialTarget({
    required String identify,
    required TargetPosition position,
    required ContentAlign alignment,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required int step,
    required String buttonText,
  }) {
    return TargetFocus(
      identify: identify,
      targetPosition: position,
      shape: ShapeLightFocus.Circle,
      paddingFocus: 0,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: alignment,
          builder: (_, tutorialController) => TutorialContent(
            icon: icon,
            iconColor: color,
            title: title,
            description: description,
            step: step,
            totalSteps: _tutorialStepCount,
            buttonText: buttonText,
            onPressed: tutorialController.next,
          ),
        ),
      ],
    );
  }

  void _updateTopOverlaySize(Size size) {
    if (_topOverlaySize == size || !mounted) {
      return;
    }
    setState(() => _topOverlaySize = size);
  }

  void _updateBottomOverlaySize(Size size) {
    if (_bottomOverlaySize == size || !mounted) {
      return;
    }
    setState(() => _bottomOverlaySize = size);
  }

  // ── Map type settings ──
  Future<void> _openMapSettings() async {
    final chosen = await showMapSettingsSheet(
      context,
      initial: _selectedMapType,
      standardThumb: Assets.mapStandard,
      satelliteThumb: Assets.mapSatellite,
      hybridThumb: Assets.mapHybrid,
    );
    if (!mounted) return;
    if (chosen != null) setState(() => _selectedMapType = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.paddingOf(context);

    return Obx(() {
      final isDestinationSelected = !dashboardController.showBottomNav.value;
      final mapPadding = EdgeInsets.only(
        top: _topOverlaySize.height,
        bottom: isDestinationSelected
            ? _bottomOverlaySize.height + mediaPadding.bottom
            : 0,
      );
      final controlsBottom = isDestinationSelected
          ? (_bottomOverlaySize.height + mediaPadding.bottom + AppSpacing.md)
                .clamp(_defaultControlsBottom, double.infinity)
                .toDouble()
          : _defaultControlsBottom;
      final controlsTop = _topOverlaySize.height + AppSpacing.md;

      return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Stack(
            children: [
              // ── Google Map ──
              GoogleMap(
                onMapCreated: (c) {
                  _controller.complete(c);
                  _mapController = c;
                  controller.onMapCreated(c);
                },
                initialCameraPosition: CameraPosition(
                  target: controller.myCurrentLocation.value,
                  zoom: _defaultZoom,
                ),
                markers: {
                  ...controller.locationMarker,
                  ...controller.houseMarkers,
                },
                polylines: controller.polylines,
                mapType: _selectedMapType,
                padding: mapPadding,
                myLocationEnabled: true,
                onLongPress: (latLng) {
                  controller.onLongPressMap(latLng, '', '', context);
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(
                  _minZoom,
                  _maxZoom,
                ),
                trafficEnabled: true,
                onCameraMove: controller.onCameraMove,
                onCameraIdle: () => controller.onCameraIdle(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _MeasureSize(
                  onChange: _updateTopOverlaySize,
                  child: isDestinationSelected
                      ? SafeArea(
                          child: Container(
                            color: appTheme.gray25,
                            child: Padding(
                              padding: AppSpacing.symmetric(
                                horizontal: AppSpacing.screenHorizontal,
                                vertical: AppSpacing.sm,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _LocationTile(
                                    title: 'Live location',
                                    subtitle:
                                        controller.myCurrentLocationName.value,
                                    leading: _Dot(color: appTheme.errorColor),
                                  ),
                                  AppSpacing.gapSm,
                                  _LocationTile(
                                    title: 'Destination location',
                                    subtitle: splitCoordinateString(
                                      controller.myDestinationName.value,
                                    ),
                                    leading: _RoundedIcon(
                                      icon: Icons.place_rounded,
                                      iconColor: context.semantic.success,
                                      bgColor:
                                          context.semantic.successContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          constraints: const BoxConstraints(
                            minHeight: AppSizes.mapHeaderHeight,
                          ),
                          color: appTheme.white,
                          padding: EdgeInsets.only(
                            top: mediaPadding.top + 15.0,
                            left: AppSpacing.screenHorizontal,
                            right: AppSpacing.screenHorizontal,
                            bottom: AppSpacing.sm,
                          ),
                          child: SearchPanel(
                            suggestions: const ['Civil Hospital', 'Pulchowk'],
                            onTap: () => Get.toNamed(AppRoutes.search),
                            readOnly: true,
                          ),
                        ),
                ),
              ),

              // ── Map type / my location buttons ──
              _mapControls(top: controlsTop, bottom: controlsBottom),

              // ── Bottom panel (shown when a destination is selected) ──
              if (isDestinationSelected)
                BottomPanel(
                  addressTitle: splitCoordinateString(
                    controller.myDestinationName.value,
                  ),
                  addressSubtitle: controller.selectedHouseSubtitle.value,
                  onNavigate: () {},
                  onSave: () {},
                  onShare: () {},
                  onClose: () {
                    dashboardController.showBottomNav.value = true;
                    controller.clearDestination();
                  },
                  onSizeChanged: _updateBottomOverlaySize,
                )
              else
                _MeasureSize(
                  onChange: _updateBottomOverlaySize,
                  child: SizedBox(height: mediaPadding.bottom),
                ),
            ],
          ),
        ),
      );
    });
  }

  Positioned _mapControls({required double top, required double bottom}) {
    return Positioned(
      top: top,
      bottom: bottom,
      right: 8,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _openMapSettings(),
              child: Container(
                padding: AppSpacing.all(AppSpacing.md),
                decoration: _floatingBoxDecoration(),
                child: SvgPicture.asset(
                  AppAssets.iconsSvgMapType,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            AppSpacing.gapMd,
            Visibility(
              visible: controller.isMyLocationButtonVisible.value,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: GestureDetector(
                onTap: _animateToMyLocation,
                child: Container(
                  padding: AppSpacing.all(AppSpacing.md),
                  decoration: _floatingBoxDecoration(),
                  child: SvgPicture.asset(
                    AppAssets.iconsSvgVector,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _animateToMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        19.0,
      ),
    );
  }
}

class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

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

  ValueChanged<Size> onChange;
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
      onChange(newSize);
    });
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.title,
    required this.subtitle,
    required this.leading,
  });

  final String title;
  final String subtitle;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final border = context.brand.grayScale300;
    final textPrimary = context.brand.black;
    final textSecondary = context.brand.gray700;

    return Container(
      decoration: BoxDecoration(
        color: context.brand.white,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: AppTheme.light.colorScheme.shadow,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: AppSpacing.cardInsets.copyWith(
        left: AppSpacing.md,
        top: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                    color: textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapXs,
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    height: 1.35,
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _floatingBoxDecoration() => BoxDecoration(
  color: appTheme.white,
  borderRadius: AppRadius.circular(AppRadius.xxxl),
  border: Border.all(color: appTheme.gray50, width: 1.0),
  boxShadow: [
    BoxShadow(
      color: AppTheme.light.colorScheme.shadow,
      offset: Offset(0, 0.5), // x=0px, y=0.5px
      blurRadius: 1.5, // 1.5px blur
      spreadRadius: 0, // 0px spread
    ),
  ],
);

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.iconXl - AppSpacing.xs,
      height: AppSizes.iconXl - AppSpacing.xs,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: AppSpacing.sm + AppSpacing.xxs,
        height: AppSpacing.sm + AppSpacing.xxs,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _RoundedIcon extends StatelessWidget {
  const _RoundedIcon({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.iconXl - AppSpacing.xs,
      height: AppSizes.iconXl - AppSpacing.xs,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: AppSizes.iconSm, color: iconColor),
    );
  }
}

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.label,
  });

  final VoidCallback onTap;
  final String imagePath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeightSm,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.orangeBase,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.textFieldRadius,
          ),
        ),
        icon: SvgPicture.asset(
          imagePath,
          colorFilter: ColorFilter.mode(appTheme.white, BlendMode.srcIn),
          width: AppSizes.iconLg,
        ),
        label: Text(label, style: CustomTextStyles.bodyLargeButton500),
      ),
    );
  }
}
