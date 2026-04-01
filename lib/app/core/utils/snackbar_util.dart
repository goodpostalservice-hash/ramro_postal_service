import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resource/app_assets.dart';

class SSnackbarUtil {
  SSnackbarUtil._();

  // Singleton instance
  static final SSnackbarUtil instance = SSnackbarUtil._();

  static void showSnackBar({
    required BuildContext context,
    required String message,
    String? key,
    int? snackBarDuration,
    bool snackBarAtTop = false,
    required SnackBarType type,
  }) {
    final icon = _getIcon(type);
    var theme = Theme.of(context);
    var isIos = false;

    if (kIsWeb) {
      isIos = false;
    } else {
      isIos = Platform.isIOS;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
        margin: snackBarAtTop
            ? EdgeInsets.only(
                bottom: isIos
                    ? MediaQuery.of(context).size.height - 160
                    : MediaQuery.of(context).size.height - 100,
                left: 10,
                right: 10,
              )
            : null,
        duration: Duration(seconds: snackBarDuration ?? 2),
        backgroundColor: theme.colorScheme.onPrimary,
        content: ListTile(
          dense: true,
          isThreeLine: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          title: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
          ),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: SvgPicture.asset(icon, height: 24, width: 24),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalDivider(
                thickness: 1,
                color: Color(0xff8e8e8e),
                indent: 6,
                endIndent: 6,
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Icon(
                  Icons.close,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                //  SvgPicture.asset(
                //   'assets/icons/close.svg',
                //   height: 24,
                //   width: 24,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return SAppAssets.iconSuccessful;
      case SnackBarType.error:
        return SAppAssets.iconError;
      case SnackBarType.info:
        return SAppAssets.iconWarning;
      case SnackBarType.warning:
        return SAppAssets.iconWarning;
    }
  }
}

enum SnackBarType { info, warning, error, success }
