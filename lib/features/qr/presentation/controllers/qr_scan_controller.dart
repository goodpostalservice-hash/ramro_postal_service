import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../common/data/models/location_data_response.dart';
import '../../../common/data/models/location_name_request.dart';
import '../../../common/presentation/controllers/common_controller.dart';
import '../../../home/data/models/map_data_response.dart';
import 'qr_parse_service.dart';
import 'qr_permission_service.dart';

class QrScanController extends ChangeNotifier {
  QrScanController({
    required this.locationController,
    QrParseService parseService = const QrParseService(),
    QrPermissionService permissionService = const QrPermissionService(),
    ImagePicker? imagePicker,
    MobileScannerController? cameraController,
  }) : _parseService = parseService,
       _permissionService = permissionService,
       _picker = imagePicker ?? ImagePicker(),
       cameraController =
           cameraController ??
           MobileScannerController(
             detectionSpeed: DetectionSpeed.noDuplicates,
             facing: CameraFacing.back,
             torchEnabled: false,
           );

  final CommonController locationController;
  final QrParseService _parseService;
  final QrPermissionService _permissionService;
  final ImagePicker _picker;
  final MobileScannerController cameraController;

  bool isScanning = true;
  bool isProcessing = false;
  bool cameraAllowed = true;
  bool torchOn = false;
  bool isGettingAddress = false;
  String? scannedCode;
  LocationDataResponse? scannedAddress;
  QrLocationData? qrLocationData;
  bool _disposed = false;

  Future<bool> requestCameraPermission() async {
    cameraAllowed = await _permissionService.requestCameraPermission();
    notifyListeners();
    return cameraAllowed;
  }

  Future<void> openSettings() {
    return _permissionService.openSettings();
  }

  void handleLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (isScanning && scannedCode == null) {
          _startCamera();
        }
        break;
      case AppLifecycleState.inactive:
        _stopCamera();
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }

  void setTab(int index) {
    if (index == 0) {
      isScanning = true;
      scannedCode = null;
      notifyListeners();
      _startCamera(afterFrame: true);
      return;
    } else {
      isScanning = false;
      _stopCamera();
    }

    notifyListeners();
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      final capture = await cameraController.analyzeImage(image.path);
      if (capture == null || capture.barcodes.isEmpty) {
        return 'No QR code found in image';
      }

      return handleQRCodeDetected(capture.barcodes.first);
    } catch (error) {
      debugPrint('Gallery QR error: $error');
      return 'Failed to scan image';
    }
  }

  String? handleQRCodeDetected(Barcode barcode) {
    if (isProcessing) return null;

    final rawValue = barcode.rawValue ?? barcode.displayValue ?? '';
    final parsedData = _parseService.parseLocation(rawValue);

    if (parsedData == null) {
      return 'Invalid Ramro Postal QR code';
    }

    isProcessing = true;
    scannedCode = rawValue;
    qrLocationData = parsedData;
    notifyListeners();

    _stopCamera();
    _loadAddressFromQr();
    return null;
  }

  Future<void> toggleFlash() async {
    await cameraController.toggleTorch();
    torchOn = !torchOn;
    notifyListeners();
  }

  void resetScanner() {
    isProcessing = false;
    scannedCode = null;
    qrLocationData = null;
    scannedAddress = null;
    isGettingAddress = false;
    notifyListeners();

    _startCamera(afterFrame: true);
  }

  Future<void> _loadAddressFromQr() async {
    final data = qrLocationData;
    if (data == null) return;

    isGettingAddress = true;
    scannedAddress = null;
    notifyListeners();

    final locReq = LocationNameRequest(
      latitude: data.latitude.toString(),
      longitude: data.longitude.toString(),
    );
    final address = await locationController.getLocationName(locReq);

    scannedAddress = address;
    isGettingAddress = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopCamera();
    _disposed = true;
    cameraController.dispose();
    super.dispose();
  }

  void _startCamera({bool afterFrame = false}) {
    if (_disposed || !cameraAllowed || !isScanning) return;

    if (afterFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
      return;
    }

    cameraController.start().catchError((error) {
      debugPrint('QR scanner start error: $error');
    });
  }

  void _stopCamera() {
    if (_disposed) return;

    cameraController.stop().catchError((error) {
      debugPrint('QR scanner stop error: $error');
    });
  }
}
