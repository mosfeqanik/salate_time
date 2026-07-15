import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Maps DESIGN.md's typography tokens onto Flutter's [TextTheme] roles.
/// Headings use Source Serif 4; body/label roles use Manrope.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color onSurface) {
    return TextTheme(
      displayLarge: GoogleFonts.sourceSerif4(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        height: 56 / 48,
        letterSpacing: -0.02 * 48,
        color: onSurface,
      ),
      headlineLarge: GoogleFonts.sourceSerif4(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.sourceSerif4(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 32 / 24,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurface,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.05 * 14,
        color: onSurface,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: onSurface,
      ),
    );
  }
}
