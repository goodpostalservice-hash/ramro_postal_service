import 'package:flutter/material.dart';

import '../constants/app_exports.dart';

customBackButton(context) {
  return Container(
    width: AppSpacing.colossal,
    height: AppSpacing.colossal,
    decoration: BoxDecoration(
      color: appTheme.gray50,
      borderRadius: AppRadius.cardRadius,
    ),
    margin: AppSpacing.only(top: AppSpacing.colossal, bottom: AppSpacing.sm),
    child: IconButton(
      icon: Icon(Icons.arrow_back, color: appTheme.black),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
