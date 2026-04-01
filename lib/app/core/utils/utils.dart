import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../values/colors.dart';

class SUtils {
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  static void logPrint(String message) {
    log(message);
  }

  static String formatCoinCount(int coins) {
    if (coins > 0 && coins < 1000) {
      return coins.toString();
    } else if (coins >= 1000 && coins < 1000000) {
      return ("${coins / 1000}k");
    } else if (coins >= 1000000 && coins < 1000000000) {
      return ("${coins / 1000000}m");
    }
    return coins.toString();
  }

  static Future<void> displayBottomSheet(
    BuildContext context,
    Widget Function(ScrollController scrollController) builder, {
    double initialChildSize = 0.5,
    double minChildSize = 0.5,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: 0.9,
          snap: true,
          shouldCloseOnMinExtent: false,
          snapSizes: [minChildSize, 0.9],
          expand: false,
          builder: (context, scrollController) {
            return builder(scrollController);
          },
        );
      },
    );
  }

  static Future<T?> displayBottomDialog<T>(BuildContext context, Widget widget) {
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: SColors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.all(
            14,
          ).copyWith(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(34),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [widget]),
        );
      },
    );
  }

  static Future<void> displayErrorDialog(BuildContext context, Widget widget) {
    final theme = Theme.of(context);
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: theme.colorScheme.onError,
      builder: (_) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            14,
          ).add(EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
          decoration: BoxDecoration(color: theme.colorScheme.onError),
          child: widget,
        );
      },
    );
  }

  static Future<void> displayBottomDialogFullHeight(
    BuildContext context,
    Widget widget,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: SColors.transparent,
      context: context,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.all(
                14,
              ).copyWith(bottom: MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(34),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: widget,
              ),
            );
          },
        );
      },
    );
  }
}
