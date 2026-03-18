import 'package:flutter/material.dart';

InputDecoration customTextFormField(String myString) {
  return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      labelText: myString,
      labelStyle: const TextStyle(
          fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.normal
      ),
      // Set border for enabled state (default)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(5),
      ),
      // Set border for focused state
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.green),
        borderRadius: BorderRadius.circular(5),
      ));
}

InputDecoration passwordTextFormField(String myString, bool showVisibility) {
  return InputDecoration(
    suffixIcon: IconButton(icon: showVisibility ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: () {},),
      fillColor: Colors.white,
      filled: true,
      labelText: myString,
      labelStyle: const TextStyle(
          fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.normal
      ),
      // Set border for enabled state (default)
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(5),
      ),
      // Set border for focused state
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.green),
        borderRadius: BorderRadius.circular(5),
      ));
}