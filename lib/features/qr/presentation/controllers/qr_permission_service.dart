import 'package:permission_handler/permission_handler.dart';

class QrPermissionService {
  const QrPermissionService();

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
