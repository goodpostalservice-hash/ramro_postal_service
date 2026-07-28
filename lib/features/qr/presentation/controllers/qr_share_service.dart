import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:share_plus/share_plus.dart';

class QrShareService {
  const QrShareService();

  static const _canvasWidth = 800.0;
  static const _canvasHeight = 1000.0;
  static const _qrSize = 700.0;
  static const _qrTop = 165.0;

  /// Generates a QR card from text data, overlays a logo, adds a caption, and shares it.
  Future<void> shareQrCardWithLogoAndCaption({
    required String data,
    required String logoAssetPath,
    String caption = 'Scan to view the address',
  }) async {
    try {
      final bytes = await buildQrCardWithLogoAndCaption(
        data: data,
        logoAssetPath: logoAssetPath,
        caption: caption,
      );

      await _sharePng(bytes, filePrefix: 'qr_card');
    } catch (e) {
      debugPrint('Share QR Card Error: $e');
      rethrow;
    }
  }

  Future<Uint8List> buildQrCardWithLogoAndCaption({
    required String data,
    required String logoAssetPath,
    String caption = 'Scan to view the address',
  }) async {
    final qrImage = await QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      gapless: true,
    ).toImage(_qrSize);
    final logoImage = await _loadUiImageFromAsset(logoAssetPath);
    try {
      return await _buildStyledCard(
        qrImage: qrImage,
        logoImage: logoImage,
        caption: caption,
      );
    } finally {
      qrImage.dispose();
      logoImage.dispose();
    }
  }

  Future<void> shareRemoteQrAsStyledCard({
    required String imageUrl,
    required String logoAssetPath,
    String caption = 'Scan to view the address',
  }) async {
    try {
      ui.Image qrImage;

      if (imageUrl.toLowerCase().endsWith('.svg')) {
        final response = await Dio().get<String>(
          imageUrl,
          options: Options(responseType: ResponseType.plain),
        );
        final pictureInfo = await vg.loadPicture(
          SvgStringLoader(response.data!),
          null,
        );

        // FIX: Use the SVG's natural size to avoid adding transparent padding
        final svgSize = pictureInfo.size;
        final width = svgSize.width == 0 ? 800 : svgSize.width.toInt();
        final height = svgSize.height == 0 ? 800 : svgSize.height.toInt();

        qrImage = await pictureInfo.picture.toImage(width, height);
        pictureInfo.picture.dispose();
      } else {
        final response = await Dio().get<List<int>>(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = Uint8List.fromList(response.data!);
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        qrImage = frame.image;
      }

      final logoImage = await _loadUiImageFromAsset(logoAssetPath);
      try {
        final bytes = await _buildStyledCard(
          qrImage: qrImage,
          logoImage: logoImage,
          caption: caption,
        );
        await _sharePng(bytes, filePrefix: 'styled_qr');
      } finally {
        qrImage.dispose();
        logoImage.dispose();
      }
    } catch (error) {
      debugPrint('Share Remote QR Error: $error');
      rethrow;
    }
  }

  Future<LatLng?> getPlaceCoordinates(String placeId) async {
    final apiKey = AppConstant.googleMapAPI;
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$placeId&key=$apiKey';

    try {
      final response = await Dio().get(apiUrl);
      final json = response.data as Map<String, dynamic>;

      final results = json['results'] as List?;
      if (results == null || results.isEmpty) return null;

      final location = results[0]['geometry']['location'];
      if (location == null) return null;

      final lat = location['lat'];
      final lng = location['lng'];

      if (lat == null || lng == null) return null;

      return LatLng(lat, lng);
    } catch (error) {
      debugPrint('getPlaceCoordinates Error: $error');
      return null;
    }
  }

  // --- HELPERS ---

  Future<Uint8List> _buildStyledCard({
    required ui.Image qrImage,
    required ui.Image logoImage,
    required String caption,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 1. Draw Solid White Background
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, _canvasWidth, _canvasHeight),
      Paint()..color = Colors.white,
    );

    // 2. Draw Logo (Strictly centered in top area)
    // Box: 300x100 starting at Y=60
    final logoRect = _inscribe(
      logoImage,
      const Rect.fromLTWH(250, 60, 300, 100),
    );
    canvas.drawImageRect(
      logoImage,
      Rect.fromLTWH(
        0,
        0,
        logoImage.width.toDouble(),
        logoImage.height.toDouble(),
      ),
      logoRect,
      Paint()..filterQuality = FilterQuality.high,
    );

    // 3. Draw QR Image (Huge and strictly centered in middle area)
    // Box: 650x650 starting at Y=200
    final qrRect = _inscribe(qrImage, const Rect.fromLTWH(75, 200, 650, 650));
    canvas.drawImageRect(
      qrImage,
      Rect.fromLTWH(0, 0, qrImage.width.toDouble(), qrImage.height.toDouble()),
      qrRect,
      Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true,
    );

    // 4. Draw Caption (Perfectly placed at bottom)
    _drawCaption(
      canvas: canvas,
      text: caption,
      top: 900.0, // 100px from the bottom edge
      maxWidth: _canvasWidth,
      fontSize: 32.0,
      color: Colors.black,
    );

    // 5. Convert to PNG
    final finalImage = await recorder.endRecording().toImage(
      _canvasWidth.toInt(),
      _canvasHeight.toInt(),
    );
    try {
      final byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw StateError('Unable to encode the QR card as PNG.');
      }
      return byteData.buffer.asUint8List();
    } finally {
      finalImage.dispose();
    }
  }

  /// Helper: Scales an image to fit inside a bounding box (like BoxFit.contain)
  Rect _inscribe(ui.Image image, Rect bounds) {
    final imageW = image.width.toDouble();
    final imageH = image.height.toDouble();

    final scale = (bounds.width / imageW).clamp(0.0, bounds.height / imageH);
    final w = imageW * scale;
    final h = imageH * scale;

    return Rect.fromLTWH(
      bounds.left + (bounds.width - w) / 2,
      bounds.top + (bounds.height - h) / 2,
      w,
      h,
    );
  }
}

Future<void> _sharePng(Uint8List bytes, {required String filePrefix}) async {
  final directory = await getTemporaryDirectory();
  final file = File(
    '${directory.path}/${filePrefix}_${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(bytes, flush: true);
  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
  );
}

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
  final paragraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontSize: fontSize,
    fontWeight: ui.FontWeight.w600,
    height: 1.2,
    fontFamily: 'Roboto',
  );
  final textStyle = ui.TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: ui.FontWeight.w600,
  );

  final paragraph =
      (ui.ParagraphBuilder(paragraphStyle)
            ..pushStyle(textStyle)
            ..addText(text))
          .build()
        ..layout(ui.ParagraphConstraints(width: maxWidth));

  canvas.drawParagraph(paragraph, ui.Offset(0, top));
}
