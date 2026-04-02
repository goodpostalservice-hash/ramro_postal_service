import 'package:flutter/material.dart';

import '../themes/theme_helper.dart';
import 'size_utils.dart';

class AppDecoration {
  // Black decorations
  static BoxDecoration get black => BoxDecoration(color: appTheme.black900);

  // Fill decorations
  static BoxDecoration get fillBlack =>
      BoxDecoration(color: appTheme.black900.withOpacity(0.28));
  static BoxDecoration get fillDeepOrange =>
      BoxDecoration(color: appTheme.orangeBase);
  static BoxDecoration get fillGray => BoxDecoration(color: appTheme.gray100);
  static BoxDecoration get fillGray100 =>
      BoxDecoration(color: appTheme.gray100);

  static BoxDecoration get fillGray200 =>
      BoxDecoration(color: appTheme.gray200);
  static BoxDecoration get fillInverseSurface =>
      BoxDecoration(color: theme.colorScheme.inverseSurface);

  static BoxDecoration get fillPrimary =>
      BoxDecoration(color: theme.colorScheme.primary);
  static BoxDecoration get fillPrimaryContainer =>
      BoxDecoration(color: theme.colorScheme.primaryContainer);
  static BoxDecoration get fillSecondaryContainer =>
      BoxDecoration(color: theme.colorScheme.secondaryContainer);

  // Outline decorations
  static BoxDecoration get outlineBlueGray => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(
      bottom: BorderSide(color: appTheme.gray200, width: getHorizontalSize(1)),
    ),
  );
  static BoxDecoration get outlineGray => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border.all(color: appTheme.gray300, width: getHorizontalSize(1)),
  );

  // White decorations
  static BoxDecoration get white =>
      BoxDecoration(color: theme.colorScheme.onPrimary);
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder19 =>
      BorderRadius.circular(getHorizontalSize(19));
  static BorderRadius get circleBorder40 =>
      BorderRadius.circular(getHorizontalSize(40));
  static BorderRadius get circleBorder51 =>
      BorderRadius.circular(getHorizontalSize(51));
  static BorderRadius get circleBorder70 =>
      BorderRadius.circular(getHorizontalSize(70));
  static BorderRadius get circleBorder81 =>
      BorderRadius.circular(getHorizontalSize(81));
  static BorderRadius get circleBorder9 =>
      BorderRadius.circular(getHorizontalSize(9));

  // Custom borders
  static BorderRadius get customBorderTL16 =>
      BorderRadius.vertical(top: Radius.circular(getHorizontalSize(16)));

  // Rounded borders
  static BorderRadius get roundedBorder12 =>
      BorderRadius.circular(getHorizontalSize(12));
  static BorderRadius get roundedBorder16 =>
      BorderRadius.circular(getHorizontalSize(16));
  static BorderRadius get roundedBorder27 =>
      BorderRadius.circular(getHorizontalSize(27));
  static BorderRadius get roundedBorder6 =>
      BorderRadius.circular(getHorizontalSize(6));
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
