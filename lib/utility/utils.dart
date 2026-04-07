import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

// toast message widget
showToast(String message, Color color) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

onShare(BuildContext context, String referCode) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  Share.share(
    referCode,
    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
  );
}
