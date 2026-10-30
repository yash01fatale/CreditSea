import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme({required bool dark}) {
    final primary = dark ? const Color(0xFFE8EEF7) : AppColors.textPrimary;
    final secondary = dark ? const Color(0xFFA5B4C7) : AppColors.textSecondary;
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.manrope(color: primary, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.2),
      displaySmall: GoogleFonts.manrope(color: primary, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
      headlineLarge: GoogleFonts.manrope(color: primary, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -.7),
      headlineMedium: GoogleFonts.manrope(color: primary, fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -.5),
      headlineSmall: GoogleFonts.manrope(color: primary, fontSize: 19, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.manrope(color: primary, fontSize: 17, fontWeight: FontWeight.w800),
      titleMedium: GoogleFonts.inter(color: primary, fontSize: 15, fontWeight: FontWeight.w700),
      bodyLarge: GoogleFonts.inter(color: primary, fontSize: 15),
      bodyMedium: GoogleFonts.inter(color: secondary, fontSize: 13),
      bodySmall: GoogleFonts.inter(color: secondary, fontSize: 11),
      labelLarge: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  static ThemeData get lightTheme => _build(dark: false);
  static ThemeData get darkTheme => _build(dark: true);

  static ThemeData _build({required bool dark}) {
    const primary = AppColors.primary;
    const blue = AppColors.secondary;
    final background = dark ? const Color(0xFF0B1220) : const Color(0xFFF6F8FC);
    final surface = dark ? const Color(0xFF151F2E) : Colors.white;
    final text = dark ? const Color(0xFFE8EEF7) : AppColors.textPrimary;
    final muted = dark ? const Color(0xFFA5B4C7) : AppColors.textSecondary;
    final line = dark ? const Color(0xFF2B3B50) : const Color(0xFFE7ECF3);

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: (dark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
        primary: blue,
        secondary: const Color(0xFF20C997),
        error: AppColors.error,
        surface: surface,
        onSurface: text,
      ),
      textTheme: _textTheme(dark: dark),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(color: text, fontWeight: FontWeight.w800, fontSize: 19),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: line)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF1B2839) : const Color(0xFFFAFBFD),
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: line)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: blue, width: 1.5)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: dark ? const Color(0xFF1B3152) : const Color(0xFFEAF0FF),
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(fontSize: 11, fontWeight: selected ? FontWeight.w800 : FontWeight.w500, color: selected ? blue : muted);
        }),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1),
      iconTheme: IconThemeData(color: muted),
      snackBarTheme: SnackBarThemeData(backgroundColor: dark ? const Color(0xFF26364B) : primary, contentTextStyle: const TextStyle(color: Colors.white)),
    );
  }
}
