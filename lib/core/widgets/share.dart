import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareQrSvgAsPng(String imageUrl) async {
  try {
    final fullUrl = imageUrl.startsWith("http")
        ? imageUrl
        : "https://ramropostalservice.com$imageUrl";

    final response = await Dio().get<List<int>>(
      fullUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final svgBytes = Uint8List.fromList(response.data!);

    final loader = SvgBytesLoader(svgBytes);
    final pictureInfo = await vg.loadPicture(loader, null);

    final image = await pictureInfo.picture.toImage(800, 800);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    pictureInfo.picture.dispose();

    if (byteData == null) {
      throw Exception("PNG conversion failed");
    }

    final pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();

    final pngPath =
        "${tempDir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png";

    final pngFile = File(pngPath);
    await pngFile.writeAsBytes(pngBytes);

    print("PNG PATH: $pngPath");
    print("PNG SIZE: ${await pngFile.length()}");

    await Share.shareXFiles([
      XFile(pngFile.path, mimeType: "image/png", name: "qr_code.png"),
    ], text: "QR Code");
  } catch (e, s) {
    print("QR SHARE ERROR: $e");
    print("QR SHARE STACK: $s");
  }
}
