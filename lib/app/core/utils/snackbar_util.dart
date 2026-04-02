import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SSnackbarUtil {
  SSnackbarUtil._();

  static showSnackbar(String title, String message, SnackbarType? type) {
    Color color = Colors.grey.shade300;
    switch (type ?? SnackbarType.info) {
      case SnackbarType.info:
        color = Colors.grey.shade300;
        break;
      case SnackbarType.warning:
        color = Colors.red.shade300;
        break;
      case SnackbarType.error:
        color = Colors.red.shade300;
        break;
      case SnackbarType.success:
        color = Colors.green.shade300;
        break;
    }
    var newMessage = message.replaceAll(RegExp(r"^Exception:"), "");

    if (Get.context != null) {
      Get.rawSnackbar(
        // title,
        // message,
        borderRadius: 1,
        borderWidth: 1,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
        forwardAnimationCurve: Curves.elasticIn,
        reverseAnimationCurve: Curves.elasticIn,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,

        // title,
        message: newMessage,
        // icon: const Icon(Icons.info),
        // titleText: Text(
        //   title,
        //   style: Get.textTheme.titleMedium!
        //       .copyWith(color: Get.theme.colorScheme.onPrimary),
        // ),
        duration: const Duration(seconds: 2),
        // mainButton: TextButton.icon(
        //   onPressed: () => Get.back(),
        //   icon: const Icon(
        //     Icons.cancel,
        //     color: SColors.white,
        //   ),
        //   label: const Text(''),
        // ),
        messageText: Text(
          newMessage,
          maxLines: 4,
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Get.theme.colorScheme.onPrimary,
          ),
        ),
        // borderRadius: 12,
        // borderWidth: 2,
        borderColor: color.withOpacity(0.8),
        barBlur: 1,
        // snackStyle: SnackStyle.GROUNDED,
        // overlayColor: SColors.white,
        // colorText: SColors.white,
        // snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
      );
    } else {}
  }
}

enum SnackbarType { info, warning, error, success }
