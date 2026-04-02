import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/s_spacing.dart';

class ConfirmDialogBottomSheet extends StatelessWidget {
  const ConfirmDialogBottomSheet({
    super.key,
    required this.title,
    required this.cancelButtonName,
    required this.doneButtonName,
    required this.onCancel,
    required this.onDone,
  });

  final String title;
  final String cancelButtonName;
  final String doneButtonName;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: 10,
            top: 26,
          ),
          height: 150,
          child: Column(
            children: [
              Text(title, style: Get.textTheme.titleLarge),
              SSpacing.lgH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: Text(cancelButtonName),
                    ),
                  ),
                  SSpacing.mdW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDone,
                      child: Text(doneButtonName),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
