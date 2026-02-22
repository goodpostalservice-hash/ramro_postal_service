import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogLoadingHelper {
  static void showLoading() {
    Get.dialog(const Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height:10),
        CircularProgressIndicator(),
        SizedBox(height:10),
      ]),
    ));
  }

  static void hideLoading() {
    Get.back();
  }
}