import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SValidator {
  static String? emailValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Required*';
    } else if (!value!.isEmail) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static String? stringValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required*';
    } else {
      return null;
    }
  }

  static String? numericOnlyValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Required*';
    } else if (double.tryParse(value ?? 's') == null) {
      return 'Enter valid number';
    } else {
      return null;
    }
  }

  static String? numberValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required*';
    }

    if (value.length < 10 || value.length > 12) {
      return 'Invalid number';
    }

    if (!value.startsWith('+')) {
      if (value.isNumericOnly) {
        return null;
      } else {
        return 'Invalid number';
      }
    }

    if (value.substring(1).isNumericOnly) {
      return null;
    } else {
      return 'Invalid number';
    }
  }

  static String? comissionValidator(String? value) {
    if (value!.isEmpty) {
      return 'Invalid number';
    }

    if (!value.startsWith('+')) {
      if (value.isNumericOnly) {
        return null;
      } else {
        return 'Invalid number';
      }
    }

    if (value.substring(1).isNumericOnly) {
      return null;
    } else {
      return 'Invalid number';
    }
  }

  static String? passwordValidator(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter your password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Must contain 8 Characters, 1 Uppercase ,1 Lowercase,\n 1 Special character, 1 number and no whitespace';
      } else {
        return null;
      }
    }
  }

  static String? validateConfirmPassword(
    String confirmPassword,
    String password,
  ) {
    // Confirm password must match the original password.
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? otpValidator(String? value) {
    if (value!.length != 6) {
      return 'Invalid otp';
    } else {
      return null;
    }
  }

  static Color getOutlineColor(bool isItAValidPassword) {
    if (isItAValidPassword) {
      return Get.theme.colorScheme.secondary;
    } else {
      return Get.theme.colorScheme.tertiary;
    }
  }

  static Color getPasswordSameOutlineColor(String pw, String cpw) {
    if (cpw == "") {
      return Get.theme.colorScheme.tertiary;
    } else if (pw == cpw) {
      return Get.theme.colorScheme.tertiary;
    } else {
      return Get.theme.colorScheme.tertiary;
    }
  }
}
