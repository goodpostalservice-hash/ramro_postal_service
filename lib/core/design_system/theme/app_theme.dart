import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_sizes.dart';
import '../tokens/app_spacing.dart';
import 'app_theme_extensions.dart';

/// Main Ramro app theme.
///
/// Replace your old `ThemeHelper` slowly with this file. It keeps the same
/// orange/gray brand direction from `lib(2).zip`, but moves styling into one
/// clean ThemeData + ThemeExtension system.
class AppTheme {
  const AppTheme._();

  static const String primaryFontFamily = 'SF Pro Display';
  static const String secondaryFontFamily = 'Gilroy';

  static ThemeData get light => _buildLightTheme();

  static const ColorScheme lightColorScheme = ColorScheme.light(
    brightness: Brightness.light,

    // Brand orange from the current project.
    primary: Color(0xFFFF910D),
    onPrimary: Color(0xFFFAFAF9),
    primaryContainer: Color(0xFFFFEAD1),
    onPrimaryContainer: Color(0xFF101010),

    secondary: Color(0xFFD67500),
    onSecondary: Color(0xFFFAFAF9),
    secondaryContainer: Color(0xFFFFD39E),
    onSecondaryContainer: Color(0xFF101010),

    tertiary: Color(0xFFFFA73D),
    onTertiary: Color(0xFFFAFAF9),
    tertiaryContainer: Color(0xFFFFD39E),
    onTertiaryContainer: Color(0xFF101010),

    // Surfaces and text.
    surface: Color(0xFFFAFAF9),
    onSurface: Color(0xFF101010),
    surfaceContainerHighest: Color(0xFFF8F8F7),
    onSurfaceVariant: Color(0xFF787878),

    // Borders/dividers.
    outline: Color(0xFFC4C4C4),
    outlineVariant: Color(0xFFE3E3E2),

    // Destructive/error. For success/warning/info use AppSemanticColors.
    error: Color(0xFFFF3E3E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFE1E1),
    onErrorContainer: Color(0xFF8B0000),

    inverseSurface: Color(0xFF2B2B2B),
    onInverseSurface: Color(0xFFFAFAF9),
    inversePrimary: Color(0xFFFFBE70),

    shadow: Color(0x1F000000),
    scrim: Color(0x99000000),
    surfaceTint: Colors.transparent,
  );

  static ThemeData _buildLightTheme() {
    const scheme = lightColorScheme;
    final textTheme = _buildTextTheme(scheme);

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: primaryFontFamily,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,

      extensions: const <ThemeExtension<dynamic>>[
        AppBrandColors.light,
        AppSemanticColors.light,
        AppMapColors.light,
      ],

      appBarTheme: _buildAppBarTheme(scheme, textTheme),
      inputDecorationTheme: _buildInputDecorationTheme(scheme, textTheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(scheme, textTheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(scheme, textTheme),
      cardTheme: _buildCardTheme(scheme),
      bottomSheetTheme: _buildBottomSheetTheme(scheme),
      dialogTheme: _buildDialogTheme(scheme, textTheme),
      snackBarTheme: _buildSnackBarTheme(scheme, textTheme),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.dividerThickness,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: AppSizes.iconLg),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.primaryContainer,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          if (states.contains(WidgetState.disabled)) return scheme.outline;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: scheme.outline, width: 1),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme scheme) {
    const baseColor = Color(0xFF101010);
    const mutedColor = Color(0xFF787878);

    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.4,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: secondaryFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: mutedColor,
      ),
      labelLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: mutedColor,
      ),
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );
  }

  static AppBarTheme _buildAppBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: scheme.onSurface, size: AppSizes.iconLg),
      actionsIconTheme: IconThemeData(
        color: scheme.onSurface,
        size: AppSizes.iconLg,
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFAFAF9),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final border = OutlineInputBorder(
      borderRadius: AppRadius.textFieldRadius,
      borderSide: BorderSide(color: scheme.outlineVariant, width: 1),
    );

    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: AppBrandColors.light.white,
      contentPadding: AppSpacing.inputContentPadding,
      hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: scheme.error,
        height: 1.2,
      ),
      border: border,
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.primary, width: 1.2),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 1.2),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 1.2),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(0, AppSizes.buttonHeight),
        ),
        padding: WidgetStateProperty.all(AppSpacing.buttonPadding),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          return 0;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled))
            return AppBrandColors.light.gray400;
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled))
            return AppBrandColors.light.gray600;
          return scheme.onPrimary;
        }),
        textStyle: WidgetStateProperty.all(textTheme.labelLarge),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        ),
        overlayColor: WidgetStateProperty.all(
          scheme.onPrimary.withOpacity(0.08),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(0, AppSizes.buttonHeight),
        ),
        padding: WidgetStateProperty.all(AppSpacing.buttonPadding),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled))
            return scheme.surfaceContainerHighest;
          return AppBrandColors.light.white;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled))
            return AppBrandColors.light.gray600;
          return scheme.primary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: scheme.outlineVariant);
          }
          return BorderSide(color: scheme.primary, width: 1);
        }),
        textStyle: WidgetStateProperty.all(textTheme.labelLarge),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
        ),
        overlayColor: WidgetStateProperty.all(scheme.primary.withOpacity(0.08)),
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme scheme) {
    return CardThemeData(
      color: AppBrandColors.light.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: scheme.shadow,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius,
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: AppBrandColors.light.white,
      modalBackgroundColor: AppBrandColors.light.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      showDragHandle: true,
      dragHandleColor: scheme.outlineVariant,
      dragHandleSize: const Size(36, 4),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheetRadius,
      ),
    );
  }

  static DialogThemeData _buildDialogTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return DialogThemeData(
      backgroundColor: AppBrandColors.light.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      actionTextColor: scheme.inversePrimary,
      disabledActionTextColor: scheme.onInverseSurface.withOpacity(0.5),
      elevation: 0,
      insetPadding: AppSpacing.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
    );
  }
}

/// Compatibility with your current `GetMaterialApp(theme: theme)` style.
ThemeData get theme => AppTheme.light;

/// Compatibility with old `appTheme.orangeBase` usage while migrating.
/// Prefer `context.brand.orangeBase` in new code.
AppBrandColors get appTheme => AppBrandColors.light;
