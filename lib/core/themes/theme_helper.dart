import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../constants/size_utils.dart'; // for getFontSize()
import '../../shared_preference/sharedpreference.dart'; // PrefUtils()

final ThemeHelper _themeHelperSingleton = ThemeHelper();

ThemeData get theme => _themeHelperSingleton.themeData();
PrimaryColors get appTheme => _themeHelperSingleton.themeColor();

class ThemeHelper {
  ThemeHelper();

  String get _appThemeKey => PrefUtils().getThemeData();

  final Map<String, ThemeData> _cachedByKey = {};

  static final Map<String, PrimaryColors> _supportedCustomColors = {
    'primary': PrimaryColors(),
  };

  static final Map<String, ColorScheme> _supportedColorSchemes = {
    'primary': ColorSchemes.primary,
  };

  PrimaryColors themeColor() {
    final colors = _supportedCustomColors[_appThemeKey];
    if (colors == null) {
      throw Exception(
        'Unknown theme key: $_appThemeKey. Make sure it is registered in ThemeHelper._supportedCustomColors.',
      );
    }
    return colors;
  }

  /// Expose current ThemeData (memoized per theme key).
  ThemeData themeData() {
    if (_cachedByKey.containsKey(_appThemeKey)) {
      return _cachedByKey[_appThemeKey]!;
    }
    final built = _buildThemeForKey(_appThemeKey);
    _cachedByKey[_appThemeKey] = built;
    return built;
  }

  void changeTheme(String newKey) {
    PrefUtils().setThemeData(newKey);
    _cachedByKey.remove(newKey); // defensive; not strictly required
    _cachedByKey.clear();
    Get.forceAppUpdate();
  }

  /// Build ThemeData for a given key.
  ThemeData _buildThemeForKey(String key) {
    final scheme = _supportedColorSchemes[key];
    if (scheme == null) {
      throw Exception(
        'Unknown theme key: $key. Make sure it is registered in ThemeHelper._supportedColorSchemes.',
      );
    }

    return ThemeData(
      // Global font family (you still override per-style in TextThemes).
      fontFamily: 'SF Pro Display',
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
      useMaterial3: false,
      // Your text theme
      textTheme: TextThemes.textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFFF910D), // your app color
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: appTheme.gray25,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      // Global ProgressIndicator styling
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appTheme.orangeBase,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.orangeBase,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          side: BorderSide(color: scheme.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.onSurface;
        }),
        side: const BorderSide(width: 1),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray200,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: appTheme.white,
        surfaceTintColor: appTheme.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: appTheme.white,
        surfaceTintColor: appTheme.white,
      ),
    );
  }
}

/// ------------------------------
/// Text Styles
/// ------------------------------
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(16),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      height: 1.2,
    ),
    bodyMedium: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(14),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      height: 1.2,
    ),
    bodySmall: TextStyle(
      color: appTheme.gray600,
      fontSize: getFontSize(12),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w400,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(32),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    headlineSmall: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(24),
      fontFamily: 'Gilroy',
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(20),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(18),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
    titleSmall: TextStyle(
      color: appTheme.black900,
      fontSize: getFontSize(14),
      fontFamily: 'SF Pro Display',
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
  );
}

/// ------------------------------
/// Color Schemes
/// ------------------------------
class ColorSchemes {
  static const primary = ColorScheme.light(
    brightness: Brightness.light,

    // Brand (Primary – Orange)
    primary: Color(0xFFFF910D), // Base
    onPrimary: Color(0xFFFAFAF9), // Gray 25 (near-white)
    primaryContainer: Color(0xFFFFBE70), // 25
    onPrimaryContainer: Color(0xFF101010), // Black
    // Secondary & Tertiary from orange scale
    secondary: Color(0xFFD67500), // 100
    onSecondary: Color(0xFFFAFAF9), // Gray 25
    secondaryContainer: Color(0xFFFFD39E), // 0
    onSecondaryContainer: Color(0xFF101010),

    tertiary: Color(0xFFFFA73D), // 50
    onTertiary: Color(0xFFFAFAF9), // Gray 25
    tertiaryContainer: Color(0xFFFFD39E), // 0
    onTertiaryContainer: Color(0xFF101010),

    // Surfaces (Grayscale)
    surface: Color(0xFFFAFAF9), // Gray 25
    onSurface: Color(0xFF101010), // Black
    surfaceContainerHighest: Color(0xFFF8F8F7), // Gray 100
    onSurfaceVariant: Color(0xFF787878), // Gray 700
    // Outline / Divider
    outline: Color(0xFFC4C4C4), // Gray 300
    outlineVariant: Color(0xFFABABAB), // Gray 400
    // Feedback (kept within orange/gray palette)
    error: Color(0xFFA35900), // 200 (orange tone)
    onError: Color(0xFFFAFAF9), // Gray 25
    errorContainer: Color(0xFFFFD39E), // 0
    onErrorContainer: Color(0xFF101010),

    // Inverse
    inverseSurface: Color(0xFF2B2B2B), // Gray 950
    onInverseSurface: Color(0xFFFAFAF9), // Gray 25
    inversePrimary: Color(0xFFA35900), // 200
    // Required fields
    shadow: Color(0x1F000000),
    scrim: Color(0x99000000),
    surfaceTint: Colors.transparent,
  );
}

/// ------------------------------
/// Design Token Colors
/// ------------------------------
class PrimaryColors {
  // Buttons / common
  Color get buttonColor => const Color(0xFF000000);
  Color get secondaryColor => const Color(0xFFF8F8F7);
  Color get white => const Color(0xFFFFFFFF);
  Color get errorColor => const Color(0xFFFF3E3E);

  // Black
  Color get black900 => const Color(0xFF000000);
  Color get black1000 => const Color(0xFF181B25);
  Color get black10 => const Color(0xFFF4F4F4);
  Color get black40 => const Color(0xFF696969);
  Color get black30 => const Color(0xFFC0C0C0);
  Color get black20 => const Color(0xFFDCDCDC);

  // Grayscale
  Color get gray25 => const Color(0xFFFAFAF9);
  Color get gray50 => const Color(0xFFF5F5F4);
  Color get gray100 => const Color(0xFFF8F8F7);
  Color get gray200 => const Color(0xFFE3E3E2);
  Color get gray300 => const Color(0xFFC4C4C4);
  Color get grayScale300 => const Color(0xFFE6E6E6);
  Color get gray400 => const Color(0xFFD5D5D5); // for borders
  Color get gray500 => const Color(0xFF919191);
  Color get gray600 => const Color(0xFF787878);
  Color get gray700 => const Color(0xFF6C6C6C);
  Color get gray800 => const Color(0xFF5E5E5E);
  Color get grayScale800 => const Color(0xFF515151);
  Color get gray900 => const Color(0xFF454545);
  Color get gray950 => const Color(0xFF2B2B2B);
  Color get black => const Color(0xFF101010);

  // Primary Orange Scale
  Color get orange0 => const Color(0xFFFFD39E);
  Color get orangeLight => const Color(0xFFFFEAD1);
  Color get orange25 => const Color(0xFFFFBE70);
  Color get orange50 => const Color(0xFFFFA73D);
  Color get orangeBase => const Color(0xFFFF910D);
  Color get orange100 => const Color(0xFFD67500);
  Color get orange200 => const Color(0xFFA35900);
  Color get orange300 => const Color(0xFF6B3A00);
  Color get orange400 => const Color(0xFF381F00);
  Color get orange500 => const Color(0xFF1A0E00);
}

Widget animationFunction(
  index,
  child, {
  Duration? listAnimation,
  Duration? slideduration,
  Duration? slidedelay,
}) {
  return AnimationConfiguration.staggeredList(
    position: index,
    duration: listAnimation ?? Duration(milliseconds: 375),
    child: SlideAnimation(
      duration: slideduration ?? Duration(milliseconds: 50),
      delay: slidedelay ?? Duration(milliseconds: 50),
      child: FadeInAnimation(child: child),
    ),
  );
}
