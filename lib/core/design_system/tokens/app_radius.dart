import 'package:flutter/widgets.dart';

/// Border radius tokens.
///
/// Use these instead of repeatedly writing `BorderRadius.circular(15)` or
/// `BorderRadius.circular(999)` in feature screens.
class AppRadius {
  const AppRadius._();

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;

  /// Common semantic radii.
  static const double button = md;
  static const double textField = 15.0;
  static const double card = xl;
  static const double bottomSheet = xxxl;
  static const double dialog = xxl;
  static const double chip = 999.0;
  static const double circle = 999.0;

  static BorderRadius circular(double value) => BorderRadius.circular(value);

  static final BorderRadius buttonRadius = BorderRadius.circular(button);
  static final BorderRadius textFieldRadius = BorderRadius.circular(textField);
  static final BorderRadius cardRadius = BorderRadius.circular(card);
  static final BorderRadius dialogRadius = BorderRadius.circular(dialog);
  static final BorderRadius chipRadius = BorderRadius.circular(chip);

  static const BorderRadius bottomSheetRadius = BorderRadius.vertical(
    top: Radius.circular(bottomSheet),
  );
}
