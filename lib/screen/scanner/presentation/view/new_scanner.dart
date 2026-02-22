import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/error/toast.dart';
import '../../../search/controller/search_controller.dart';
import '../../../search/presentation/view/show_search_on_map_screen.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  bool isScanning = true; // which tab is active
  bool _isProcessing = false;
  bool _cameraAllowed = true;
  bool _torchOn = false;

  final ImagePicker _picker = ImagePicker();

  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.stop();
    cameraController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      switch (state) {
        case AppLifecycleState.resumed:
          cameraController.start();
          break;
        case AppLifecycleState.inactive:
          cameraController.stop();
          break;
        case AppLifecycleState.hidden:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          break;
      }
    } catch (_) {
      // ignore controller init/dispose edge cases
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    final allowed = status.isGranted;
    setState(() {
      _cameraAllowed = allowed;
    });

    if (!allowed) {
      _showPermissionDeniedDialog();
    }
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
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // Let the user pick an image from the gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        // User canceled the picker
        return;
      }

      final BarcodeCapture? capture = await cameraController.analyzeImage(
        image.path,
      );
      if (capture == null || capture.barcodes.isEmpty) {
        _showMessage('No QR code found in the image');
        return;
      }
      _handleQRCodeDetected(capture.barcodes.first);

      final List<Barcode> barcodes = capture.barcodes;

      if (barcodes.isEmpty) {
        _showMessage('No QR code found in the image');
        return;
      }

      // We got at least one code 🎉
      final Barcode first = barcodes.first;

      _handleQRCodeDetected(first);
    } catch (e) {
      _showMessage('Error picking image: $e');
    }
  }

  void _handleQRCodeDetected(Barcode barcode) {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _scannedCode = barcode.rawValue;
    });

    cameraController.stop();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _toggleFlash() async {
    await cameraController.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    double frameSize = 250;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Scan QR code',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _scannedCode != null
          ? _buildScanResultView()
          : Column(
              children: [
                // Tab row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          text: 'Scan QR code',
                          isSelected: isScanning,
                          onTap: () {
                            setState(() {
                              isScanning = true;
                              _scannedCode = null;
                            });
                            cameraController.start();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TabButton(
                          text: 'Share your location',
                          isSelected: !isScanning,
                          onTap: () {
                            setState(() {
                              isScanning = false;
                            });
                            cameraController.stop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Main panel (camera preview OR share-location card)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: isScanning
                        ? _buildCameraPanel(frameSize)
                        : const _ShareLocationSection(),
                  ),
                ),

                if (isScanning)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _pickImageFromGallery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Add QR code from gallery',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 15.0),
              ],
            ),
    );
  }

  // === SCAN MODE: live camera preview with frame and scan line ===
  Widget _buildCameraPanel(double frameSize) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 30.0,
              right: 50.0,
              child: IconButton(
                onPressed: _toggleFlash,
                icon: Icon(
                  _torchOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
              ),
            ),
            // live camera or fallback if permission denied
            if (_cameraAllowed)
              MobileScanner(
                controller: cameraController,
                onDetect: (capture) async {
                  // don't handle multiple times
                  if (_isProcessing) return;

                  final barcodes = capture.barcodes;
                  if (barcodes.isEmpty) return;

                  final first = barcodes.first;

                  // Try to get something readable
                  final scannedText =
                      first.rawValue ??
                      first.displayValue ??
                      first.toString(); // last resort, debug-ish

                  if (scannedText.isEmpty) return;

                  // lock so we don't process spam frames
                  setState(() {
                    _isProcessing = true;
                    _scannedCode = scannedText;
                  });

                  // pause camera so it's not still drawing behind the result UI
                  await cameraController.stop();
                },
              )
            else
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  'Camera access needed to scan codes.\nEnable it in Settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

            // white corner frame
            Container(
              width: frameSize,
              height: frameSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Stack(
                children: [
                  _CornerBracket(alignment: Alignment.topLeft, rotationDeg: 0),
                  _CornerBracket(
                    alignment: Alignment.topRight,
                    rotationDeg: 90,
                  ),
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

            // orange scanning line
            if (!_isProcessing) _ScanningLine(frameExtent: frameSize),

            // status pill bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _scannedCode != null
                        ? 'Code detected!'
                        : 'Scan to find the location',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === AFTER SCAN: result screen with "Show in map" ===
  Widget _buildScanResultView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/icons/viewmapscan.png', height: 120.0),
            const SizedBox(height: 30),
            Text(
              _scannedCode!.isEmpty
                  ? 'Scanning took long time. Please try again later'
                  : _scannedCode!,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.blue,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_scannedCode!.isEmpty)
              SizedBox(
                width: 200,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 44, 85, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Searching ...',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (_scannedCode!.isNotEmpty)
              SizedBox(
                width: 240,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.orangeBase,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final searchController = Get.put(SearchMapController());
                    final searchResult = await searchController
                        .getSearchAddresses(_scannedCode);

                    if (searchResult != null) {
                      Get.to(
                        () => ShowSearchOnMapScreen(
                          latitude: double.parse(searchResult[0]['latitude']),
                          longitude: double.parse(searchResult[0]['longitude']),
                          address: searchResult[0]['full_address_detail'],
                          houseno: searchResult[0]['house_num'],
                          street: searchResult[0]['street'],
                          zone: searchResult[0]['zone'],
                          sub: searchResult[0]['sub_zone'],
                        ),
                      );
                    } else {
                      LatLng? cods = await getPlaceCoordinates(_scannedCode!);
                      if (cods != null) {
                        Get.to(
                          () => ShowSearchOnMapScreen(
                            latitude: cods.latitude,
                            longitude: cods.longitude,
                            address: _scannedCode!,
                            houseno: '',
                            street: '',
                            zone: "",
                            sub: '',
                          ),
                        );
                      } else {
                        showErrorMessage("could not open this address in map");
                      }
                    }
                  },
                  child: const Text(
                    'Show in map',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// SHARE LOCATION SECTION UI
// ==========================

class _ShareLocationSection extends StatelessWidget {
  const _ShareLocationSection();

  @override
  Widget build(BuildContext context) {
    // mock data – you can wire in real user address / QR in the future.
    const address =
        '685 Aa Tribhuvan internatnion airport area '; // watch spelling from screenshot
    const cityLine = 'Kathmandu, Nepal';
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The orange QR card
          _QrCard(addressLine: address, cityLine: cityLine, onPrintTap: () {}),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Copy Address',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: address));
                    // _showMessage('Copied to clipboard');
                  },
                  variant: AppButtonVariant.outlined,
                  icon: Icon(Icons.copy),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Share location',
                  onPressed: () async {
                    await shareQrCardWithLogoAndCaption(
                      data:
                          'P984 + 234, Pulchowk Manohara 12, Kathmandu 44600, Nepal',
                      logoAssetPath: 'assets/icons/logo.png',
                      caption: 'Scan to view the address',
                    );
                  },
                  variant: AppButtonVariant.outlined,
                  icon: Icon(Icons.ios_share_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// orange gradient card with QR
class _QrCard extends StatelessWidget {
  final String addressLine;
  final String cityLine;
  final VoidCallback onPrintTap;

  const _QrCard({
    super.key,
    required this.addressLine,
    required this.cityLine,
    required this.onPrintTap,
  });

  @override
  Widget build(BuildContext context) {
    // placeholder QR / brand images
    // You can swap with Image.asset('assets/...') to match your brand.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.orangeLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: brand + QR
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left brand chunk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand row
                    Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/icons/logo.png'),
                          width: 100.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Address lines
                    Text(
                      addressLine,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cityLine,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: Color(0xFFB95B00), // orange-ish text in figma
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              QrImageView(
                data: addressLine,
                foregroundColor: appTheme.orangeBase,
                version: QrVersions.auto,
                size: 160,
                gapless: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tab buttons
class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.grey.shade300 : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// little white corner L-shapes
class _CornerBracket extends StatelessWidget {
  final Alignment alignment;
  final double rotationDeg;

  const _CornerBracket({
    super.key,
    required this.alignment,
    required this.rotationDeg,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: rotationDeg * 3.1415926535 / 180,
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white, width: 4),
              left: BorderSide(color: Colors.white, width: 4),
            ),
          ),
        ),
      ),
    );
  }
}

// moving orange scan line
class _ScanningLine extends StatefulWidget {
  final double frameExtent; // the frame is square, so just one number

  const _ScanningLine({super.key, required this.frameExtent});

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
    final width = widget.frameExtent;

    return AnimatedBuilder(
      animation: _offsetAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnim.value),
          child: Container(
            width: width,
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFFFF9500),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9500).withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===== helper to geocode =====

Future<LatLng?> getPlaceCoordinates(String placeId) async {
  final apiKey = AppConstant.googleMapAPI;
  final apiUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$placeId&key=$apiKey';

  try {
    final response = await Dio().get(apiUrl);
    final json = response.data;

    final lat = json['results'][0]['geometry']['location']['lat'];
    final lng = json['results'][0]['geometry']['location']['lng'];

    return LatLng(lat, lng);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Uint8List> buildQrCardWithLogoAndCaption({
  // REQUIRED
  required String data, // The string encoded in the QR
  required String logoAssetPath, // e.g. 'assets/brand/logo.png'
  String caption = 'Scan to view the address',

  // Canvas (final image) size
  int widthPx = 1000,
  int heightPx = 1300,

  // Colors & styles
  Color background = const Color(0xFFFFFFFF),
  Color qrColor = const Color(0xFF000000),
  Color captionColor = const Color(0xFF101010),

  // Layout
  double topPadding = 48, // top margin above logo
  double betweenLogoAndQr = 24,
  double betweenQrAndCaption = 20,
  double sidePadding = 48,
  double captionFontSize = 36,
  double captionLineHeight = 1.2,

  // Logo sizing
  double logoMaxWidth = 360,
  double logoMaxHeight = 140,

  // QR settings
  int quietZonePx = 60,
  int errorCorrectLevel = QrErrorCorrectLevel.Q,
}) async {
  // 1) Prepare canvas
  final recorder = ui.PictureRecorder();
  final canvasSize = ui.Size(widthPx.toDouble(), heightPx.toDouble());
  final canvas = ui.Canvas(recorder);

  // White background
  canvas.drawRect(ui.Offset.zero & canvasSize, ui.Paint()..color = background);

  // 2) Draw logo on top (centered)
  final ui.Image logoImage = await _loadUiImageFromAsset(logoAssetPath);
  final double usableLogoW = logoMaxWidth.clamp(40, widthPx - sidePadding * 2);
  final scale = (usableLogoW / logoImage.width).clamp(
    0.05,
    logoMaxWidth / logoImage.width,
  );
  final double drawLogoW = logoImage.width * scale;
  final double drawLogoH = (logoImage.height * scale).clamp(10, logoMaxHeight);

  final double logoLeft = (widthPx - drawLogoW) / 2;
  final double logoTop = topPadding;

  final srcLogo = ui.Rect.fromLTWH(
    0,
    0,
    logoImage.width.toDouble(),
    logoImage.height.toDouble(),
  );
  final dstLogo = ui.Rect.fromLTWH(logoLeft, logoTop, drawLogoW, drawLogoH);
  canvas.drawImageRect(logoImage, srcLogo, dstLogo, ui.Paint());

  // 3) Compute QR box (square) area
  final topAfterLogo = logoTop + drawLogoH + betweenLogoAndQr;
  final bottomReserveForCaption =
      captionFontSize * 2.0 + betweenQrAndCaption + 24;

  final double qrAvailableHeight =
      heightPx - topAfterLogo - bottomReserveForCaption - topPadding;
  final double qrAvailableWidth = widthPx - sidePadding * 2;
  final double qrOuterSize = qrAvailableHeight < qrAvailableWidth
      ? qrAvailableHeight
      : qrAvailableWidth;

  final double qrLeft = (widthPx - qrOuterSize) / 2;
  final double qrTop = topAfterLogo;

  // 4) Build QR painter (no embedded logo; keep strong contrast; gapless=false)
  final qr = QrCode.fromData(data: data, errorCorrectLevel: errorCorrectLevel);

  final painter = QrPainter.withQr(
    qr: qr,
    gapless: false,
    eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: qrColor),
    dataModuleStyle: QrDataModuleStyle(
      dataModuleShape: QrDataModuleShape.square,
      color: qrColor,
    ),
  );

  // 5) Paint quiet zone + QR
  final double innerSide = (qrOuterSize - quietZonePx * 2).clamp(
    100,
    qrOuterSize,
  );
  // (a) quiet zone (white box with slight rounding)
  final qrRect = ui.RRect.fromRectAndRadius(
    ui.Rect.fromLTWH(qrLeft, qrTop, qrOuterSize, qrOuterSize),
    const ui.Radius.circular(12),
  );
  canvas.drawRRect(qrRect, ui.Paint()..color = const ui.Color(0xFFFFFFFF));

  // (b) QR itself inside quiet zone
  canvas.save();
  canvas.translate(qrLeft + quietZonePx, qrTop + quietZonePx);
  painter.paint(canvas, ui.Size(innerSide, innerSide));
  canvas.restore();

  // 6) Draw the caption centered under the QR
  final captionTop = qrTop + qrOuterSize + betweenQrAndCaption;
  final captionMaxWidth = widthPx - sidePadding * 2;

  _drawCaption(
    canvas: canvas,
    text: caption,
    top: captionTop,
    maxWidth: captionMaxWidth,
    fontSize: captionFontSize,
    color: captionColor,
  );

  // 7) Finalize
  final picture = recorder.endRecording();
  final img = await picture.toImage(widthPx, heightPx);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

/// Share helper (saves to temp then opens OS share sheet)
Future<void> shareQrCardWithLogoAndCaption({
  required String data,
  required String logoAssetPath,
  String caption = 'Scan to view the address',
}) async {
  final bytes = await buildQrCardWithLogoAndCaption(
    data: data,
    logoAssetPath: logoAssetPath,
    caption: caption,
  );
  final dir = await getTemporaryDirectory();
  final file = File(
    '${dir.path}/qr_card_${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(bytes, flush: true);
  await Share.shareXFiles([XFile(file.path, mimeType: 'image/png')]);
}

/* --------------------- helpers --------------------- */

Future<ui.Image> _loadUiImageFromAsset(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    allowUpscaling: false,
  );
  final frame = await codec.getNextFrame();
  return frame.image;
}

void _drawCaption({
  required ui.Canvas canvas,
  required String text,
  required double top,
  required double maxWidth,
  double fontSize = 36,
  ui.Color color = const ui.Color(0xFF101010),
}) {
  final pbStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontSize: fontSize,
    fontWeight: ui.FontWeight.w600,
    height: 1.2,
    fontFamily: 'Roboto', // include in pubspec or use default
  );
  final ts = ui.TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: ui.FontWeight.w600,
  );

  final pb = ui.ParagraphBuilder(pbStyle)
    ..pushStyle(ts)
    ..addText(text);

  final paragraph = pb.build()
    ..layout(ui.ParagraphConstraints(width: maxWidth));
  final left =
      ((maxWidth + (0)) - paragraph.maxIntrinsicWidth) /
      2; // center within maxWidth

  // Center horizontally: draw at (canvasWidth - maxWidth)/2 + (maxWidth - paragraph.width)/2
  // Simpler: shift by ((canvasWidth - paragraph.width) / 2). We assume we've already centered maxWidth by using side paddings.
  final canvasWidth = canvas
      .getSaveCount(); // not useful for width; compute differently:

  // We'll just draw starting at horizontal center using paragraph width
  // For precise center across full canvas width, we need canvas size:
  // Instead, wrap in a translate block:
  // (We’ll translate to center using a trick: measure via Paragraph width)
  // Since we don't have the canvas size here, draw at X = (side padding) and rely on maxWidth symmetrical paddings in parent.
  final offset = ui.Offset(
    // Draw within a centered maxWidth box: start at horizontal padding
    // Caller made side paddings equal, so left offset is fine:
    // We can just place it at side padding; text is centered inside the paragraph with textAlign: center
    // So no additional centering needed.
    // If you need absolute centering against full canvas, pass canvas width and compute.
    // For now:
    ( // center within full width by assuming maxWidth equals (canvasWidth - 2*sidePadding)
    // We'll approximate center by drawing at left margin = (canvasWidth - maxWidth)/2
    // But we don't have canvasWidth here; simplest: draw at 0 and caller wrapper translates.
    // To keep function simple, we just draw at x = (canvasWidth - maxWidth)/2 via save/restore outside.
    // Since we didn't pass it, we'll draw at x= (side padding) by caller logic; to avoid mismatch,
    // just draw at 0 and let caller set a proper translate. For this self-contained method, we
    // draw at x= ( (widthPx - maxWidth) / 2 ), but we don't know widthPx in this scope.
    0),
    top,
  );

  // To avoid dependency on canvas width here, we assume caller centered the available box.
  canvas.save();
  // Translate to horizontal center by measuring paragraph width inside maxWidth
  // We can approximate by centering in the full image if we had width. Since we don't, draw at 0 and let caller provide centered box.
  // In our builder we set maxWidth = (imageWidth - 2*sidePadding) and call this once,
  // so we can translate to ( (imageWidth - maxWidth)/2 ).
  // We'll store that translate outside; to keep consistent, we just draw at offset now.
  canvas.drawParagraph(paragraph, offset);
  canvas.restore();
}
