import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/size_utils.dart';
import 'package:ramro_postal_service/core/themes/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style

  //----------body large-----------------------
  static get bodyLarge17 =>
      theme.textTheme.bodyLarge!.copyWith(fontSize: getFontSize(17));
  static get bodyLargeButton500 => theme.textTheme.bodyLarge!.copyWith(
    fontWeight: FontWeight.w500,
    color: appTheme.gray25,
  );
  static get bodyLargeButton500Orange => theme.textTheme.bodyLarge!.copyWith(
    fontWeight: FontWeight.w500,
    color: appTheme.orange200,
  );
  static get bodyLargeblack => theme.textTheme.bodyLarge;
  static get bodyLargeblack500 => theme.textTheme.bodyLarge!.copyWith(
    fontWeight: FontWeight.w500,
    color: appTheme.black,
  );
  static get bodyLargeGray_16_500 => theme.textTheme.bodyLarge!.copyWith(
    fontWeight: FontWeight.w500,
    color: appTheme.gray25,
  );

  static get bodyLargeGray800 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray800,
    height: 1.37,
  );
  //----------body medium-----------------------
  static get bodyMediumGray400 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.gray400);
  static get bodyMediumBlack14_400 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.black);
  static get bodyMediumGray14_400 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.gray800);
  static get bodyMediumBlack1000_14_500 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.black1000);
  static get bodyMediumBlack_14_500 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.black);
  static get bodyMediumGrey_14_500 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.grayScale800);
  static get bodyMediumGray600 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.gray600);

  //----------body small-----------------------
  static get bodySmallBlack12_400 =>
      theme.textTheme.bodySmall!.copyWith(color: appTheme.black900);
  static get bodySmallOrange12_400 =>
      theme.textTheme.bodySmall!.copyWith(color: appTheme.orangeBase);
  static get bodySmallGray12_400 =>
      theme.textTheme.bodySmall!.copyWith(color: appTheme.gray950);
  static get bodySmallGray800_12_400 =>
      theme.textTheme.bodySmall!.copyWith(color: appTheme.gray800);

  //----------title large-----------------------
  static get titleLargeBlack20_500 =>
      theme.textTheme.titleLarge!.copyWith(color: appTheme.black);

  //----------title medium-----------------------
  static get titleMediumBlack18_500 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.black);

  //----------title small-----------------------
  static get titleSmall => theme.textTheme.titleSmall;
  static get titleSmallBlack =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.black);

  //----------headline medium-----------------------
  static get headlineMedium_32_600 => theme.textTheme.headlineMedium;
  //----------headline small-----------------------
  static get headlineSmall_24_500 =>
      theme.textTheme.headlineSmall!.copyWith(color: appTheme.black);

  static get bodyErrorStyle =>
      theme.textTheme.bodyMedium!.sFProDisplay.copyWith(
        color: appTheme.errorColor,
        fontWeight: FontWeight.w400,
        fontSize: getFontSize(16),
      );
}

extension on TextStyle {
  TextStyle get sFProDisplay {
    return copyWith(fontFamily: 'SF Pro Display');
  }

  TextStyle get sFProText {
    return copyWith(fontFamily: 'SF Pro Text');
  }
}
