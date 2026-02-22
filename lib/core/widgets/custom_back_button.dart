import 'package:flutter/material.dart';

import '../constants/app_export.dart';

customBackButton(context) {
  return Container(
    width: getHorizontalSize(40.0),
    height: getVerticalSize(40.0),
    decoration: BoxDecoration(
      color: appTheme.gray50,
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.only(top: 40.0, bottom: 10.0),
    child: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
