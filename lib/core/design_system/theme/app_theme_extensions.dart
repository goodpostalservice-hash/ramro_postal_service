import 'package:flutter/material.dart';

/// Ramro brand color tokens.
///
/// These values are based on the existing `PrimaryColors` from
/// `core/themes/theme_helper.dart`, but moved into ThemeExtension so screens
/// can read them from `Theme.of(context)` instead of global hardcoded values.
@immutable
class AppBrandColors extends ThemeExtension<AppBrandColors> {
  const AppBrandColors({
    required this.buttonColor,
    required this.secondaryColor,
    required this.white,
    required this.errorColor,
    required this.black900,
    required this.black1000,
    required this.black10,
    required this.black40,
    required this.black30,
    required this.black20,
    required this.gray25,
    required this.gray50,
    required this.gray100,
    required this.gray200,
    required this.gray300,
    required this.grayScale300,
    required this.gray400,
    required this.gray500,
    required this.gray600,
    required this.gray700,
    required this.gray800,
    required this.grayScale800,
    required this.gray900,
    required this.gray950,
    required this.black,
    required this.orange0,
    required this.orangeLight,
    required this.orange25,
    required this.orange50,
    required this.orangeBase,
    required this.orange100,
    required this.orange200,
    required this.orange300,
    required this.orange400,
    required this.orange500,
  });

  final Color buttonColor;
  final Color secondaryColor;
  final Color white;
  final Color errorColor;

  final Color black900;
  final Color black1000;
  final Color black10;
  final Color black40;
  final Color black30;
  final Color black20;

  final Color gray25;
  final Color gray50;
  final Color gray100;
  final Color gray200;
  final Color gray300;
  final Color grayScale300;
  final Color gray400;
  final Color gray500;
  final Color gray600;
  final Color gray700;
  final Color gray800;
  final Color grayScale800;
  final Color gray900;
  final Color gray950;
  final Color black;

  final Color orange0;
  final Color orangeLight;
  final Color orange25;
  final Color orange50;
  final Color orangeBase;
  final Color orange100;
  final Color orange200;
  final Color orange300;
  final Color orange400;
  final Color orange500;

  static const light = AppBrandColors(
    buttonColor: Color(0xFF000000),
    secondaryColor: Color(0xFFF8F8F7),
    white: Color(0xFFFFFFFF),
    errorColor: Color(0xFFFF3E3E),
    black900: Color(0xFF000000),
    black1000: Color(0xFF181B25),
    black10: Color(0xFFF4F4F4),
    black40: Color(0xFF696969),
    black30: Color(0xFFC0C0C0),
    black20: Color(0xFFDCDCDC),
    gray25: Color(0xFFFAFAF9),
    gray50: Color(0xFFF5F5F4),
    gray100: Color(0xFFF8F8F7),
    gray200: Color(0xFFE3E3E2),
    gray300: Color(0xFFC4C4C4),
    grayScale300: Color(0xFFE6E6E6),
    gray400: Color(0xFFD5D5D5),
    gray500: Color(0xFF919191),
    gray600: Color(0xFF787878),
    gray700: Color(0xFF6C6C6C),
    gray800: Color(0xFF5E5E5E),
    grayScale800: Color(0xFF515151),
    gray900: Color(0xFF454545),
    gray950: Color(0xFF2B2B2B),
    black: Color(0xFF101010),
    orange0: Color(0xFFFFD39E),
    orangeLight: Color(0xFFFFEAD1),
    orange25: Color(0xFFFFBE70),
    orange50: Color(0xFFFFA73D),
    orangeBase: Color(0xFFFF910D),
    orange100: Color(0xFFD67500),
    orange200: Color(0xFFA35900),
    orange300: Color(0xFF6B3A00),
    orange400: Color(0xFF381F00),
    orange500: Color(0xFF1A0E00),
  );

  @override
  AppBrandColors copyWith({
    Color? buttonColor,
    Color? secondaryColor,
    Color? white,
    Color? errorColor,
    Color? black900,
    Color? black1000,
    Color? black10,
    Color? black40,
    Color? black30,
    Color? black20,
    Color? gray25,
    Color? gray50,
    Color? gray100,
    Color? gray200,
    Color? gray300,
    Color? grayScale300,
    Color? gray400,
    Color? gray500,
    Color? gray600,
    Color? gray700,
    Color? gray800,
    Color? grayScale800,
    Color? gray900,
    Color? gray950,
    Color? black,
    Color? orange0,
    Color? orangeLight,
    Color? orange25,
    Color? orange50,
    Color? orangeBase,
    Color? orange100,
    Color? orange200,
    Color? orange300,
    Color? orange400,
    Color? orange500,
  }) {
    return AppBrandColors(
      buttonColor: buttonColor ?? this.buttonColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      white: white ?? this.white,
      errorColor: errorColor ?? this.errorColor,
      black900: black900 ?? this.black900,
      black1000: black1000 ?? this.black1000,
      black10: black10 ?? this.black10,
      black40: black40 ?? this.black40,
      black30: black30 ?? this.black30,
      black20: black20 ?? this.black20,
      gray25: gray25 ?? this.gray25,
      gray50: gray50 ?? this.gray50,
      gray100: gray100 ?? this.gray100,
      gray200: gray200 ?? this.gray200,
      gray300: gray300 ?? this.gray300,
      grayScale300: grayScale300 ?? this.grayScale300,
      gray400: gray400 ?? this.gray400,
      gray500: gray500 ?? this.gray500,
      gray600: gray600 ?? this.gray600,
      gray700: gray700 ?? this.gray700,
      gray800: gray800 ?? this.gray800,
      grayScale800: grayScale800 ?? this.grayScale800,
      gray900: gray900 ?? this.gray900,
      gray950: gray950 ?? this.gray950,
      black: black ?? this.black,
      orange0: orange0 ?? this.orange0,
      orangeLight: orangeLight ?? this.orangeLight,
      orange25: orange25 ?? this.orange25,
      orange50: orange50 ?? this.orange50,
      orangeBase: orangeBase ?? this.orangeBase,
      orange100: orange100 ?? this.orange100,
      orange200: orange200 ?? this.orange200,
      orange300: orange300 ?? this.orange300,
      orange400: orange400 ?? this.orange400,
      orange500: orange500 ?? this.orange500,
    );
  }

  @override
  AppBrandColors lerp(ThemeExtension<AppBrandColors>? other, double t) {
    if (other is! AppBrandColors) return this;

    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppBrandColors(
      buttonColor: lerpColor(buttonColor, other.buttonColor),
      secondaryColor: lerpColor(secondaryColor, other.secondaryColor),
      white: lerpColor(white, other.white),
      errorColor: lerpColor(errorColor, other.errorColor),
      black900: lerpColor(black900, other.black900),
      black1000: lerpColor(black1000, other.black1000),
      black10: lerpColor(black10, other.black10),
      black40: lerpColor(black40, other.black40),
      black30: lerpColor(black30, other.black30),
      black20: lerpColor(black20, other.black20),
      gray25: lerpColor(gray25, other.gray25),
      gray50: lerpColor(gray50, other.gray50),
      gray100: lerpColor(gray100, other.gray100),
      gray200: lerpColor(gray200, other.gray200),
      gray300: lerpColor(gray300, other.gray300),
      grayScale300: lerpColor(grayScale300, other.grayScale300),
      gray400: lerpColor(gray400, other.gray400),
      gray500: lerpColor(gray500, other.gray500),
      gray600: lerpColor(gray600, other.gray600),
      gray700: lerpColor(gray700, other.gray700),
      gray800: lerpColor(gray800, other.gray800),
      grayScale800: lerpColor(grayScale800, other.grayScale800),
      gray900: lerpColor(gray900, other.gray900),
      gray950: lerpColor(gray950, other.gray950),
      black: lerpColor(black, other.black),
      orange0: lerpColor(orange0, other.orange0),
      orangeLight: lerpColor(orangeLight, other.orangeLight),
      orange25: lerpColor(orange25, other.orange25),
      orange50: lerpColor(orange50, other.orange50),
      orangeBase: lerpColor(orangeBase, other.orangeBase),
      orange100: lerpColor(orange100, other.orange100),
      orange200: lerpColor(orange200, other.orange200),
      orange300: lerpColor(orange300, other.orange300),
      orange400: lerpColor(orange400, other.orange400),
      orange500: lerpColor(orange500, other.orange500),
    );
  }
}

/// Semantic status colors.
///
/// Use these instead of hardcoding green, yellow, red, or blue in feature files.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color onDangerContainer;

  static const light = AppSemanticColors(
    success: Color(0xFF16A34A),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF166534),
    warning: Color(0xFFD97706),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF92400E),
    info: Color(0xFF2563EB),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFDBEAFE),
    onInfoContainer: Color(0xFF1E40AF),
    danger: Color(0xFFDC2626),
    onDanger: Color(0xFFFFFFFF),
    dangerContainer: Color(0xFFFEE2E2),
    onDangerContainer: Color(0xFF991B1B),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppSemanticColors(
      success: lerpColor(success, other.success),
      onSuccess: lerpColor(onSuccess, other.onSuccess),
      successContainer: lerpColor(successContainer, other.successContainer),
      onSuccessContainer: lerpColor(onSuccessContainer, other.onSuccessContainer),
      warning: lerpColor(warning, other.warning),
      onWarning: lerpColor(onWarning, other.onWarning),
      warningContainer: lerpColor(warningContainer, other.warningContainer),
      onWarningContainer: lerpColor(onWarningContainer, other.onWarningContainer),
      info: lerpColor(info, other.info),
      onInfo: lerpColor(onInfo, other.onInfo),
      infoContainer: lerpColor(infoContainer, other.infoContainer),
      onInfoContainer: lerpColor(onInfoContainer, other.onInfoContainer),
      danger: lerpColor(danger, other.danger),
      onDanger: lerpColor(onDanger, other.onDanger),
      dangerContainer: lerpColor(dangerContainer, other.dangerContainer),
      onDangerContainer: lerpColor(onDangerContainer, other.onDangerContainer),
    );
  }
}

/// Map-specific colors.
///
/// Keep these here so map marker, route, pickup, and destination colors do not
/// become hardcoded inside map screens.
@immutable
class AppMapColors extends ThemeExtension<AppMapColors> {
  const AppMapColors({
    required this.pickup,
    required this.destination,
    required this.route,
    required this.routeBorder,
    required this.currentLocation,
    required this.markerBackground,
    required this.markerText,
    required this.clusterBackground,
    required this.clusterText,
  });

  final Color pickup;
  final Color destination;
  final Color route;
  final Color routeBorder;
  final Color currentLocation;
  final Color markerBackground;
  final Color markerText;
  final Color clusterBackground;
  final Color clusterText;

  static const light = AppMapColors(
    pickup: Color(0xFF16A34A),
    destination: Color(0xFFFF910D),
    route: Color(0xFFFF910D),
    routeBorder: Color(0xFFA35900),
    currentLocation: Color(0xFF2563EB),
    markerBackground: Color(0xFFFFFFFF),
    markerText: Color(0xFF101010),
    clusterBackground: Color(0xFFFFEAD1),
    clusterText: Color(0xFFA35900),
  );

  @override
  AppMapColors copyWith({
    Color? pickup,
    Color? destination,
    Color? route,
    Color? routeBorder,
    Color? currentLocation,
    Color? markerBackground,
    Color? markerText,
    Color? clusterBackground,
    Color? clusterText,
  }) {
    return AppMapColors(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      route: route ?? this.route,
      routeBorder: routeBorder ?? this.routeBorder,
      currentLocation: currentLocation ?? this.currentLocation,
      markerBackground: markerBackground ?? this.markerBackground,
      markerText: markerText ?? this.markerText,
      clusterBackground: clusterBackground ?? this.clusterBackground,
      clusterText: clusterText ?? this.clusterText,
    );
  }

  @override
  AppMapColors lerp(ThemeExtension<AppMapColors>? other, double t) {
    if (other is! AppMapColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppMapColors(
      pickup: lerpColor(pickup, other.pickup),
      destination: lerpColor(destination, other.destination),
      route: lerpColor(route, other.route),
      routeBorder: lerpColor(routeBorder, other.routeBorder),
      currentLocation: lerpColor(currentLocation, other.currentLocation),
      markerBackground: lerpColor(markerBackground, other.markerBackground),
      markerText: lerpColor(markerText, other.markerText),
      clusterBackground: lerpColor(clusterBackground, other.clusterBackground),
      clusterText: lerpColor(clusterText, other.clusterText),
    );
  }
}

extension AppThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  AppBrandColors get brand =>
      Theme.of(this).extension<AppBrandColors>() ?? AppBrandColors.light;

  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;

  AppMapColors get mapColors =>
      Theme.of(this).extension<AppMapColors>() ?? AppMapColors.light;
}
