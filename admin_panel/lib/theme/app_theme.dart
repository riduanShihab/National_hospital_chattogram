import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Clinical Clarity & Care Color Palette from DESIGN.md
  static const Color primary = Color(0xFF006096);
  static const Color primaryContainer = Color(0xFF007ABC);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFDFCFF);
  static const Color primaryFixed = Color(0xFFCEE5FF);
  static const Color primaryFixedDim = Color(0xFF96CCFF);
  static const Color onPrimaryFixed = Color(0xFF001D32);

  static const Color secondary = Color(0xFF0060A8);
  static const Color secondaryContainer = Color(0xFF47A1FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF003663);
  static const Color secondaryFixed = Color(0xFFD3E4FF);
  static const Color secondaryFixedDim = Color(0xFFA2C9FF);

  static const Color tertiary = Color(0xFF006A42);
  static const Color tertiaryContainer = Color(0xFF008654);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFF6FFF5);
  static const Color tertiaryFixed = Color(0xFF78FBB6);
  static const Color tertiaryFixedDim = Color(0xFF59DE9B);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color background = Color(0xFFFAF8FF);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);

  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF3F4851);
  static const Color outline = Color(0xFF707882);
  static const Color outlineVariant = Color(0xFFBFC7D2);

  static const String hotline = '09648250250';
  static const String hotlineDisplay = '০৯৬৪৮-২৫০২৫০';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.hindSiliguri(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: onSurface,
        ),
        displayMedium: GoogleFonts.hindSiliguri(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.hindSiliguri(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: onSurface,
        ),
        headlineSmall: GoogleFonts.hindSiliguri(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: onSurface,
        ),
        titleMedium: GoogleFonts.hindSiliguri(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.hindSiliguri(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.hindSiliguri(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurface,
        ),
        bodySmall: GoogleFonts.hindSiliguri(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.hindSiliguri(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.hindSiliguri(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelSmall: GoogleFonts.hindSiliguri(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface.withAlpha(230),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: const IconThemeData(color: onSurface),
        titleTextStyle: GoogleFonts.hindSiliguri(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1A707882), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.hindSiliguri(
          color: onSurfaceVariant.withAlpha(180),
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLowest,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
