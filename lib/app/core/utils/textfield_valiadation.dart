class ValidatorUtils {
  String? validateFName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter first name';
    }
    if (value is! String) {
      return 'Invalid input type. Please enter a valid last name';
    }
    return null;
  }

  String? validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    if (value is! String) {
      return 'Invalid input type. Please enter a valid last name';
    }
    return null;
  }

  String? validateLName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter last name';
    }
    return null;
  }

  String? validatePhone(value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
    RegExp regExp = RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;

    // var len = value.toString().length;
    // if (value == null || value.isEmpty) {
    //   return 'Please Enter Your Mobile Number';
    // } else if (len < 10) {
    //   return 'Mobile Number format incorrect';
    // } else if (len > 10) {
    //   return "Mobile Number exceeded.";
    // }
    // return null;
  }

  String? validateEmail(value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value) || value == null) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(value) {
    // String pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      // Check individual conditions
      if (value.length < 7) {
        return 'Password must be at least 8 characters';
      }

      if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }

      if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }

      if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
        return 'Password must contain at least one digit';
      }

      if (!RegExp(r'(?=.*?[!_@#\$&*~-])').hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
    }
    return null;
  }

  String? validateConfirmPassword(String confirmPassword, String password) {
    // Confirm password must match the original password.
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }

    // Assuming that the OTP should be a 6-digit number
    if (value.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid 6-digit OTP';
    }
    return null; // Return null if the validation passes
  }
}
