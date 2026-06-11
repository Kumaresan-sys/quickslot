import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0F6FD6);
  static const Color primaryDark = Color(0xFF0A4A9D);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const Color lightBackground = Color(0xFFF6F8FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEAF1F8);
  static const Color lightText = Color(0xFF111827);
  static const Color lightMutedText = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFDCE5EF);

  static const Color darkBackground = Color(0xFF07111F);
  static const Color darkSurface = Color(0xFF111C2D);
  static const Color darkSurfaceAlt = Color(0xFF17263A);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkMutedText = Color(0xFF9AA8BC);
  static const Color darkBorder = Color(0xFF26384F);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
}

class AppTheme {
  static final _fontFamily = GoogleFonts.inter().fontFamily;

  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceAlt: AppColors.lightSurfaceAlt,
    text: AppColors.lightText,
    mutedText: AppColors.lightMutedText,
    border: AppColors.lightBorder,
  );

  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceAlt: AppColors.darkSurfaceAlt,
    text: AppColors.darkText,
    mutedText: AppColors.darkMutedText,
    border: AppColors.darkBorder,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceAlt,
    required Color text,
    required Color mutedText,
    required Color border,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.success,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: text,
    );

    final baseTextTheme = GoogleFonts.interTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    ).apply(bodyColor: text, displayColor: text);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: background,
      fontFamily: _fontFamily,
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: mutedText,
          letterSpacing: 0,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: text,
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        labelStyle: TextStyle(color: mutedText),
        hintStyle: TextStyle(color: mutedText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: surfaceAlt,
          disabledForegroundColor: mutedText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors(
          surfaceAlt: surfaceAlt,
          mutedText: mutedText,
          border: border,
          success: AppColors.success,
          warning: AppColors.warning,
          danger: AppColors.danger,
        ),
      ],
    );
  }
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color surfaceAlt;
  final Color mutedText;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;

  const AppThemeColors({
    required this.surfaceAlt,
    required this.mutedText,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
  });

  @override
  AppThemeColors copyWith({
    Color? surfaceAlt,
    Color? mutedText,
    Color? border,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppThemeColors(
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      mutedText: mutedText ?? this.mutedText,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>()!;
}
