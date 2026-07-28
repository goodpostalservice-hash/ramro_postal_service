import 'package:flutter/widgets.dart';

/// Spacing tokens based on the existing `SDimension` values.
///
/// Use these instead of random `SizedBox(height: 17)` or
/// `EdgeInsets.all(13)` values inside feature screens.
class AppSpacing {
  const AppSpacing._();

  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;
  static const double jumbo = 32.0;
  static const double giant = 36.0;
  static const double colossal = 40.0;
  static const double mega = 44.0;
  static const double superSize = 48.0;
  static const double ultra = 52.0;
  static const double hyper = 56.0;
  static const double epic = 60.0;

  /// Most screens in your app use horizontal padding around 16 to 20.
  static const double screenHorizontal = lg;
  static const double screenVertical = md;

  /// Common component internal padding.
  static const double fieldHorizontal = lg;
  static const double fieldVertical = 14.0;
  static const double buttonHorizontal = xl;
  static const double cardPadding = lg;

  static const SizedBox gapXxs = SizedBox(height: xxs);
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl);
  static const SizedBox gapXxxl = SizedBox(height: xxxl);

  static const SizedBox horizontalGapXxs = SizedBox(width: xxs);
  static const SizedBox horizontalGapXs = SizedBox(width: xs);
  static const SizedBox horizontalGapSm = SizedBox(width: sm);
  static const SizedBox horizontalGapMd = SizedBox(width: md);
  static const SizedBox horizontalGapLg = SizedBox(width: lg);
  static const SizedBox horizontalGapXl = SizedBox(width: xl);
  static const SizedBox horizontalGapXxl = SizedBox(width: xxl);

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );

  static const EdgeInsets pageHorizontalPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );

  static const EdgeInsets cardInsets = EdgeInsets.all(cardPadding);

  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: fieldHorizontal,
    vertical: fieldVertical,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: buttonHorizontal,
  );

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double horizontal = none, double vertical = none}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets only({
    double left = none,
    double top = none,
    double right = none,
    double bottom = none,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
