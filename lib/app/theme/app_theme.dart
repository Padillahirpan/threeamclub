import 'package:flutter/material.dart';

/// Raw design tokens (DESIGN.md §2) as static consts — usable in any
/// `const` context.
abstract final class AppPalette {
  static const Color night950 = Color(0xFF060A1A);
  static const Color night900 = Color(0xFF0B1026);
  static const Color night700 = Color(0xFF1B2140);
  static const Color dawn500 = Color(0xFFF4A261);
  static const Color dawn300 = Color(0xFFFBC89A);
  static const Color sky100 = Color(0xFFFDF6EC);
  static const Color sky300 = Color(0xFFEDE3D3);
  static const Color success500 = Color(0xFF6FCF97);
  static const Color warn500 = Color(0xFFE0A458); // gentle — never red
  static const Color ink900 = Color(0xFF1A1A1A);
  static const Color mist200 = Color(0xFFC9CEDB);
  static const Color gold400 = Color(0xFFFFC857);
}

/// Design tokens as a ThemeExtension (ARCHITECTURE.md §15).
///
/// Dark theme only in the MVP — every screen is used pre-dawn or at night.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    this.night950 = AppPalette.night950,
    this.night900 = AppPalette.night900,
    this.night700 = AppPalette.night700,
    this.dawn500 = AppPalette.dawn500,
    this.dawn300 = AppPalette.dawn300,
    this.sky100 = AppPalette.sky100,
    this.sky300 = AppPalette.sky300,
    this.success500 = AppPalette.success500,
    this.warn500 = AppPalette.warn500,
    this.ink900 = AppPalette.ink900,
    this.mist200 = AppPalette.mist200,
    this.gold400 = AppPalette.gold400,
  });

  static const AppColors standard = AppColors();

  final Color night950;
  final Color night900;
  final Color night700;
  final Color dawn500;
  final Color dawn300;
  final Color sky100;
  final Color sky300;
  final Color success500;
  final Color warn500;
  final Color ink900;
  final Color mist200;
  final Color gold400;

  @override
  AppColors copyWith({
    Color? night950,
    Color? night900,
    Color? night700,
    Color? dawn500,
    Color? dawn300,
    Color? sky100,
    Color? sky300,
    Color? success500,
    Color? warn500,
    Color? ink900,
    Color? mist200,
    Color? gold400,
  }) =>
      AppColors(
        night950: night950 ?? this.night950,
        night900: night900 ?? this.night900,
        night700: night700 ?? this.night700,
        dawn500: dawn500 ?? this.dawn500,
        dawn300: dawn300 ?? this.dawn300,
        sky100: sky100 ?? this.sky100,
        sky300: sky300 ?? this.sky300,
        success500: success500 ?? this.success500,
        warn500: warn500 ?? this.warn500,
        ink900: ink900 ?? this.ink900,
        mist200: mist200 ?? this.mist200,
        gold400: gold400 ?? this.gold400,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      night950: Color.lerp(night950, other.night950, t)!,
      night900: Color.lerp(night900, other.night900, t)!,
      night700: Color.lerp(night700, other.night700, t)!,
      dawn500: Color.lerp(dawn500, other.dawn500, t)!,
      dawn300: Color.lerp(dawn300, other.dawn300, t)!,
      sky100: Color.lerp(sky100, other.sky100, t)!,
      sky300: Color.lerp(sky300, other.sky300, t)!,
      success500: Color.lerp(success500, other.success500, t)!,
      warn500: Color.lerp(warn500, other.warn500, t)!,
      ink900: Color.lerp(ink900, other.ink900, t)!,
      mist200: Color.lerp(mist200, other.mist200, t)!,
      gold400: Color.lerp(gold400, other.gold400, t)!,
    );
  }
}

/// Text styles from DESIGN.md §3.
///
/// Typeface note: rounded sans + warm serif are still to be licensed and
/// bundled (DESIGN.md §13 open item). Until then we use the platform
/// defaults (`serif` maps to the device serif) — no network fonts, per
/// PRD FR-10.2. Tabular figures are applied where digits must not jitter.
abstract final class AppTextStyles {
  static const TextStyle timeDisplay = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.2,
  );

  static const TextStyle timer = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.2,
  );

  static const TextStyle wakeHeadline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    fontFamily: 'serif',
    height: 1.3,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(fontSize: 16, height: 1.4);

  static const TextStyle caption = TextStyle(fontSize: 13, height: 1.4);
}

/// The MVP theme: dark background, dawn accents (DESIGN.md §2).
abstract final class AppTheme {
  static ThemeData dark() {
        final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.dawn500,
        onPrimary: AppPalette.ink900,
        secondary: AppPalette.dawn300,
        surface: AppPalette.night700,
        onSurface: AppPalette.sky100,
        error: AppPalette.warn500, // never red (DESIGN.md §2)
        onError: AppPalette.ink900,
      ),
      scaffoldBackgroundColor: AppPalette.night900,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.night900,
        foregroundColor: AppPalette.sky100,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppPalette.night700,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.dawn500,
          foregroundColor: AppPalette.ink900,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.sky100,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(color: AppPalette.mist200.withValues(alpha: 0.4)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.dawn300,
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.night700,
        hintStyle: TextStyle(color: AppPalette.mist200.withValues(alpha: 0.7)),
        labelStyle: const TextStyle(color: AppPalette.mist200),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: DividerThemeData(
        color: AppPalette.mist200.withValues(alpha: 0.15),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppPalette.night700,
        contentTextStyle: TextStyle(color: AppPalette.sky100),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.night700,
        modalBackgroundColor: AppPalette.night700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppPalette.dawn500),
      chipTheme: ChipThemeData(
        backgroundColor: AppPalette.night700,
        selectedColor: AppPalette.dawn500,
        labelStyle: const TextStyle(color: AppPalette.sky100),
        checkmarkColor: AppPalette.ink900,
        side: BorderSide(color: AppPalette.mist200.withValues(alpha: 0.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    return base.copyWith(
      extensions: const <ThemeExtension<dynamic>>[AppColors.standard],
    );
  }
}
