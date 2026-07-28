import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/widgets/action_buttons.dart';
import 'package:ramro_postal_service/core/widgets/empty_state.dart';
import 'package:ramro_postal_service/core/widgets/info_card.dart';

import '../../../../core/storage/storage_util.dart';
import '../../../common/presentation/controllers/common_controller.dart';
import '../../../search/data/models/search_response.dart';
import '../../../search/presentation/bindings/search_binding.dart';
import '../../../search/presentation/bindings/show_search_on_map_binding.dart';
import '../../../search/presentation/pages/google_search_screen.dart';
import '../../../search/presentation/pages/show_search_on_map_screen.dart';
import '../bindings/qr_binding.dart';
import '../controllers/qr_controller.dart';
import '../controllers/qr_scan_controller.dart';
import '../controllers/qr_share_service.dart';
import '../../data/models/generate_qr_request.dart';
import '../widgets/qr_result_widget.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  static const _frameSize = 250.0;

  late final QrScanController _controller;
  late final QrController _qrController;

  @override
  void initState() {
    super.initState();
    _controller = QrScanController(
      locationController: Get.find<CommonController>(),
    );

    if (!Get.isRegistered<QrController>()) {
      QrBinding().dependencies();
    }
    _qrController = Get.find<QrController>();

    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.handleLifecycleState(state);
  }

  Future<void> _requestCameraPermission() async {
    final allowed = await _controller.requestCameraPermission();
    if (!mounted || allowed) return;
    _showPermissionDeniedDialog();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text('Please grant camera permission to scan QR codes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final message = await _controller.pickImageFromGallery();
    if (message != null) _showMessage(message);
  }

  void _handleQRCodeDetected(Barcode barcode) {
    final message = _controller.handleQRCodeDetected(barcode);
    if (message != null) _showMessage(message);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showInMap() {
    final data = _controller.qrLocationData;
    final addressData = _controller.scannedAddress?.data;

    if (data == null) {
      _showMessage('Invalid QR location data');
      return;
    }
    Get.to(
      () => ShowSearchOnMapScreen(
        latitude: data.latitude,
        longitude: data.longitude,
        address:
            addressData?.fullAddressDetail ??
            addressData?.locationName ??
            'Scanned QR Location',
        houseno: addressData?.houseNum ?? '',
        street: addressData?.street ?? '',
        zone: addressData?.zone ?? '',
        sub: addressData?.subZone ?? '',
        locationName: _controller.scannedAddress?.data?.locationName ?? '',
      ),
      binding: ShowSearchOnMapBinding(),
    );
  }

  Future<void> _generateQrForSelectedAddress(SearchAddress result) async {
    final latitude = result.latitude;
    final longitude = result.longitude;
    final address = result.displayAddress;

    if (latitude == null ||
        longitude == null ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      _showMessage('Selected address is missing coordinates');
      return;
    }

    final request = GenerateQrRequest(
      destinationLatitude: latitude,
      destinationLognitude: longitude,
      isStaticRoute: 0,
      userType: SStorageUtil.getUserData()!.userType!,
      auth: '1',
      label: 'home',
      fullAddress: address.isNotEmpty ? address : result.locationName,
    );

    await _qrController.generateqr(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,
      appBar: AppBar(
        backgroundColor: appTheme.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Scan QR code',
          style: CustomTextStyles.titleMediumBlack18_500.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          final scannedCode = _controller.scannedCode;
          return scannedCode != null
              ? _buildResult(scannedCode)
              : _buildScanner();
        },
      ),
    );
  }

  Widget _buildResult(String scannedCode) {
    return QrResultWidget(
      scannedCode: scannedCode,
      scannedAddress:
          _controller.scannedAddress?.data?.fullAddressDetail ??
          _controller.scannedAddress?.data?.locationName ??
          'Address not found',
      isGettingAddress: _controller.isGettingAddress,
      onShowInMap: _showInMap,
      onSearchingTap: () => Navigator.pop(context),
      onScanAgain: _controller.resetScanner,
    );
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.md,
          ),
          child: _SegmentedTabs(
            segments: const ['Scan Qr code', 'Share Your location'],
            selectedIndex: _controller.isScanning ? 0 : 1,
            onChanged: _controller.setTab,
          ),
        ),
        Expanded(
          child: Padding(
            padding: AppSpacing.pageHorizontalPadding,
            child: _controller.isScanning
                ? _buildCameraPanel()
                : Obx(() {
                    final homeQr = _qrController.homeQr;
                    final isLoading =
                        _qrController.isLoading.value ||
                        _qrController.isBottomPanelLoading.value;

                    if (isLoading && homeQr == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ShareLocationSection(
                      address: homeQr?.fullAddress,
                      qrPath: homeQr?.qrcodePath,
                      onAddAddressTap: () async {
                        final result = await Get.to(
                          () => const GoogleSearchScreen(pickAddress: true),
                          binding: SearchBinding(),
                        );
                        if (result is SearchAddress) {
                          await _generateQrForSelectedAddress(result);
                        }
                      },
                    );
                  }),
          ),
        ),
        if (_controller.isScanning)
          Padding(
            padding: AppSpacing.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryActionButton(
                height: AppSizes.buttonHeightLg,
                label: 'Add QR code from gallery',
                icon: Icons.photo_library_outlined,
                onPressed: _pickImageFromGallery,
              ),
            ),
          ),
        AppSpacing.gapLg,
      ],
    );
  }

  Widget _buildCameraPanel() {
    return Container(
      width: double.infinity,
      height: 420,
      decoration: BoxDecoration(
        color: appTheme.black,
        borderRadius: AppRadius.dialogRadius,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller.cameraController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              _handleQRCodeDetected(barcodes.first);
            },
          ),
          Container(
            width: _frameSize,
            height: _frameSize,
            decoration: BoxDecoration(borderRadius: AppRadius.cardRadius),
            child: const Stack(
              children: [
                _CornerBracket(alignment: Alignment.topLeft, rotationDeg: 0),
                _CornerBracket(alignment: Alignment.topRight, rotationDeg: 90),
                _CornerBracket(
                  alignment: Alignment.bottomLeft,
                  rotationDeg: 270,
                ),
                _CornerBracket(
                  alignment: Alignment.bottomRight,
                  rotationDeg: 180,
                ),
              ],
            ),
          ),
          if (!_controller.isProcessing) _ScanningLine(frameExtent: _frameSize),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: AppSpacing.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: appTheme.black.withValues(alpha: 0.6),
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(
                  _controller.scannedCode != null
                      ? 'Code detected!'
                      : 'Scan to find the location',
                  style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                    color: appTheme.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const _bg = Color(0x1F787880);
  static const _radius = 9.0;
  static const _pad = 2.0;
  static const _height = 41.0;

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.all(_pad),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / segments.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: selectedIndex * segmentWidth,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_radius - 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(segments.length, (i) {
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(_radius - 1),
                      onTap: () => onChanged(i),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          style: CustomTextStyles.bodyMediumBlack_14_500,
                          child: Text(
                            segments[i],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ShareLocationSection extends StatelessWidget {
  const ShareLocationSection({
    super.key,
    this.address,
    this.qrPath,
    this.cityLine = 'Kathmandu, Nepal',
    required this.onAddAddressTap,
    this.shareService = const QrShareService(),
  });

  final String? address;
  final String? qrPath;
  final String cityLine;
  final VoidCallback onAddAddressTap;
  final QrShareService shareService;

  static const _qrBaseUrl = 'https://ramropostalservice.com';

  bool get _hasAddress => address != null && address!.trim().isNotEmpty;
  bool get _hasQr => qrPath != null && qrPath!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final safeAddress = address?.trim() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: _hasQr
          ? _buildQrContent(qrPath!, safeAddress, context)
          : _hasAddress
          ? _buildAddressContent(safeAddress, context)
          : _buildEmptyState(context),
    );
  }

  Widget _buildAddressContent(String address, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationCard(address: address, subtitle: cityLine),
        const SizedBox(height: 16),
        _buildLocationActions(
          context: context,
          copyLabel: 'Copy Address',
          copyMessage: 'Address copied to clipboard',
          copyData: address,
          shareData: address,
        ),
      ],
    );
  }

  Widget _buildQrContent(String qrPath, String address, BuildContext context) {
    final qrUrl = _buildQrUrl(qrPath);
    final displayAddress = address.isNotEmpty ? address : 'Address not found';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationCard(
          address: displayAddress,
          eyebrow: 'Address',
          qrUrl: qrUrl,
          logoWidth: 64,
          qrSize: 168,
          addressStyle: CustomTextStyles.titleMediumBlack18_500.copyWith(
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.gapLg,
        _buildLocationActions(
          context: context,
          copyLabel: 'Copy Address',
          copyMessage: 'Address copied to clipboard',
          copyData: displayAddress,
          shareData: qrUrl,
        ),
      ],
    );
  }

  String _buildQrUrl(String path) {
    final trimmedPath = path.trim();
    if (trimmedPath.startsWith('http')) {
      return trimmedPath;
    }
    return '$_qrBaseUrl/$trimmedPath';
  }

  Widget _buildLocationActions({
    required BuildContext context,
    required String copyLabel,
    required String copyMessage,
    required String copyData,
    required String shareData,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ActionButtons(
        children: [
          AppButton(
            label: copyLabel,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyData));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(copyMessage)));
            },
            variant: AppButtonVariant.outlined,
            icon: const Icon(Icons.copy),
          ),
          AppButton(
            label: 'Share location',
            onPressed: () {
              shareService.shareRemoteQrAsStyledCard(
                imageUrl: shareData, // shareData is the qrUrl in this context
                logoAssetPath: AppAssets.iconsLogo,
                caption: 'Scan to view the address',
              );
            },
            variant: AppButtonVariant.outlined,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return InfoCard(
      width: double.maxFinite,
      padding: getPadding(left: 20, right: 20, top: 28, bottom: 28),
      border: Border.all(color: appTheme.gray200, width: 1),
      boxShadow: const [],
      child: EmptyState(
        title: 'No Address Added',
        message:
            'Add your delivery or pickup address to generate your QR code and share your location easily.',
        icon: Icons.location_off_outlined,
        actionLabel: 'Add Address',
        onAction: onAddAddressTap,
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.address,
    this.eyebrow,
    this.subtitle,
    this.qrUrl,
    this.logoWidth = AppSizes.logoLg,
    this.qrSize,
    this.addressStyle,
  });

  final String address;
  final String? eyebrow;
  final String? subtitle;
  final String? qrUrl;
  final double logoWidth;
  final double? qrSize;
  final TextStyle? addressStyle;

  bool get _hasQr => qrUrl != null && qrUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      width: double.infinity,
      padding: _hasQr ? const EdgeInsets.all(16) : AppSpacing.cardInsets,
      color: appTheme.orangeLight,
      borderRadius: AppRadius.card,
      boxShadow: const [],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage(AppAssets.iconsLogo),
                  width: logoWidth,
                ),
                AppSpacing.gapLg,
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!,
                    style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                      color: appTheme.orange100,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.gapXs,
                ],
                Text(
                  address,
                  style:
                      addressStyle ??
                      CustomTextStyles.bodyMediumBlack14_400.copyWith(
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  AppSpacing.gapSm,
                  Text(
                    subtitle!,
                    style: CustomTextStyles.bodyMediumBlack14_400.copyWith(
                      height: 1.3,
                      color: appTheme.orange100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_hasQr) ...[
            AppSpacing.horizontalGapMd,
            _NetworkQrImage(
              url: qrUrl!,
              size: qrSize ?? AppSizes.logoLg + AppSpacing.epic + AppSpacing.xs,
              fallbackSize: 72,
            ),
          ],
        ],
      ),
    );
  }
}

class _NetworkQrImage extends StatelessWidget {
  const _NetworkQrImage({
    required this.url,
    required this.size,
    this.fallbackSize = 48,
  });

  final String url;
  final double size;
  final double fallbackSize;

  @override
  Widget build(BuildContext context) {
    final lowerUrl = url.toLowerCase();

    return SizedBox.square(
      dimension: size,
      child: lowerUrl.endsWith('.svg')
          ? SvgPicture.network(
              url,
              fit: BoxFit.contain,
              placeholderBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Icon(
                  Icons.qr_code,
                  size: fallbackSize,
                  color: appTheme.gray600,
                ),
              ),
            ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.alignment, required this.rotationDeg});

  final Alignment alignment;
  final double rotationDeg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: rotationDeg * 3.1415926535 / 180,
        child: Container(
          width: AppSpacing.jumbo - AppSpacing.xxs,
          height: AppSpacing.jumbo - AppSpacing.xxs,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: appTheme.white, width: AppSpacing.xs),
              left: BorderSide(color: appTheme.white, width: AppSpacing.xs),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanningLine extends StatefulWidget {
  const _ScanningLine({required this.frameExtent});

  final double frameExtent;

  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    final half = widget.frameExtent / 2;
    _offsetAnim = Tween<double>(
      begin: -half,
      end: half,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnim.value),
          child: child,
        );
      },
      child: Container(
        width: widget.frameExtent,
        height: 2,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.transparent, Color(0xFFFF9500), Colors.transparent],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9500).withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
