import 'package:flutter/material.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String scanDetails = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scanBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Text(scanDetails.toString()),
      ),
    );
  }

  // Future _scanBytes() async {
  //   File file = await ImagePicker().getImage(source: ImageSource.camera).then((picked) {
  //     if (picked == null) return File('');
  //     return File(picked.path);
  //   });
  //   if (file == null) return;
  //   Uint8List bytes = file.readAsBytesSync();
  //   // String barcode = await scanner.scanBytes(bytes);
  //   setState((){
  //     scanDetails = barcode;
  //   });
  // }
}
