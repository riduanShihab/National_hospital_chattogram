import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.hindSiliguri(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: AppColors.onSurface,
        ),
        displayMedium: GoogleFonts.hindSiliguri(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.hindSiliguri(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.hindSiliguri(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.hindSiliguri(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.hindSiliguri(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.hindSiliguri(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.onSurface,
        ),
        bodySmall: GoogleFonts.hindSiliguri(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.hindSiliguri(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.hindSiliguri(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelSmall: GoogleFonts.hindSiliguri(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface.withAlpha(230),
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        titleTextStyle: GoogleFonts.hindSiliguri(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1A707882), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
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
        fillColor: AppColors.surfaceContainerLow,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.hindSiliguri(
          color: AppColors.onSurfaceVariant.withAlpha(180),
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
