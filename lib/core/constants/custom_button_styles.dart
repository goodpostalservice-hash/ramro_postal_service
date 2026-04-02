import 'package:flutter/material.dart';

import '../themes/theme_helper.dart';
import 'size_utils.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlack => ElevatedButton.styleFrom(
    backgroundColor: appTheme.black900,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
    ),
  );
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(11.00)),
    ),
  );

  static ButtonStyle get fillOnPrimary =>
      ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.onPrimary);
  static ButtonStyle get fillOrange => ElevatedButton.styleFrom(
    backgroundColor: appTheme.orange50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(17.00)),
    ),
  );
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    side: BorderSide(color: theme.colorScheme.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
    ),
  );

  static ButtonStyle get fillWhite => ElevatedButton.styleFrom(
    surfaceTintColor: appTheme.secondaryColor,
    foregroundColor: appTheme.secondaryColor,
    backgroundColor: appTheme.white,
    side: BorderSide(color: theme.colorScheme.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
    ),
  );
  static ButtonStyle get elevatedfillPrimary => ElevatedButton.styleFrom(
    backgroundColor: appTheme.orangeBase,
    disabledBackgroundColor: appTheme.orangeBase,
    side: BorderSide(color: appTheme.orangeBase),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
    ),
  );

  // static ButtonStyle get fillwhite => ElevatedButton.styleFrom(
  //   backgroundColor: appTheme.white,
  //   shape: RoundedRectangleBorder(
  //     side: BorderSide(color: Colors.red),
  //     borderRadius: BorderRadius.circular(
  //       getHorizontalSize(
  //         12.00,
  //       ),
  //     ),
  //   ),
  // );
  static ButtonStyle get fillPrimaryTL7 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(7.00)),
    ),
  );

  // Outline button style
  static ButtonStyle get outlineBlack => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getHorizontalSize(3.00)),
    ),
    shadowColor: appTheme.black900.withOpacity(0.16),
    elevation: 4,
  );
  // text button style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
  );
}
