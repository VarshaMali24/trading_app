import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  // Colors matching 021 Trade's clean light UI
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textMuted = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color positiveGreen = Color(0xFF1B8B4B);
  static const Color negativeRed = Color(0xFFD32F2F);
  static const Color tabIndicator = Color(0xFF000000);
  static const Color bottomNavActive = Color(0xFF000000);
  static const Color bottomNavInactive = Color(0xFFAAAAAA);
  static const Color dragHandle = Color(0xFFCCCCCC);
  static const Color editSurface = Color(0xFFF8F8F8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.1,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimary,
        unselectedLabelColor: textMuted,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: tabIndicator, width: 2.5),
        ),
        labelStyle: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: divider,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: bottomNavActive,
        unselectedItemColor: bottomNavInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
