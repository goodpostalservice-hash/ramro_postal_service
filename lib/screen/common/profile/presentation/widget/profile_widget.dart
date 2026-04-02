import 'package:flutter/material.dart';

import '../../../../../resource/color.dart';

InputDecoration customInputDecoration(bool editable) {
  return InputDecoration(
    fillColor: AppColors.normalBG,
    contentPadding: const EdgeInsets.all(8.0),
    filled: true,
    isDense: true,
    enabled: editable,
    // Set border for enabled state (default)
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
    ),
    // Set border for focused state
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.green),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

InputDecoration addPlaceInputDecoration(bool editable) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    isDense: true,
    enabled: editable,
    // Set border for enabled state (default)
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(7),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[200]!),
      borderRadius: BorderRadius.circular(7),
    ),
    // Set border for focused state
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.green),
      borderRadius: BorderRadius.circular(7),
    ),
  );
}

InputDecoration disabledInputDecoration() {
  return InputDecoration(
    fillColor: AppColors.normalBG,
    filled: true,
    isDense: true,
    enabled: false,
    // Set border for enabled state (default)
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
    ),
    // Set border for focused state
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
