import 'package:flutter/material.dart';

/// Light-mode color tokens from DESIGN.md. Dark mode is derived at runtime
/// from [primaryContainer] via `ColorScheme.fromSeed`, not hand-authored here.
class AppColors {
  AppColors._();

  static const surface = Color(0xFFFFF8F5);
  static const surfaceDim = Color(0xFFE0D8D5);
  static const surfaceBright = Color(0xFFFFF8F5);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFFAF2EE);
  static const surfaceContainer = Color(0xFFF4ECE8);
  static const surfaceContainerHigh = Color(0xFFEEE7E3);
  static const surfaceContainerHighest = Color(0xFFE9E1DD);
  static const onSurface = Color(0xFF1E1B19);
  static const onSurfaceVariant = Color(0xFF404944);
  static const inverseSurface = Color(0xFF33302D);
  static const inverseOnSurface = Color(0xFFF7EFEB);
  static const outline = Color(0xFF707974);
  static const outlineVariant = Color(0xFFBFC9C3);
  static const surfaceTint = Color(0xFF2B6954);

  static const primary = Color(0xFF003527);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF064E3B);
  static const onPrimaryContainer = Color(0xFF80BEA6);
  static const inversePrimary = Color(0xFF95D3BA);

  static const secondary = Color(0xFF9B4500);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFD8A42);
  static const onSecondaryContainer = Color(0xFF682C00);

  static const tertiary = Color(0xFF2D2F2E);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF434545);
  static const onTertiaryContainer = Color(0xFFB1B2B1);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  static const primaryFixed = Color(0xFFB0F0D6);
  static const primaryFixedDim = Color(0xFF95D3BA);
  static const onPrimaryFixed = Color(0xFF002117);
  static const onPrimaryFixedVariant = Color(0xFF0B513D);

  static const secondaryFixed = Color(0xFFFFDBCA);
  static const secondaryFixedDim = Color(0xFFFFB68E);
  static const onSecondaryFixed = Color(0xFF331200);
  static const onSecondaryFixedVariant = Color(0xFF763300);

  static const tertiaryFixed = Color(0xFFE2E2E2);
  static const tertiaryFixedDim = Color(0xFFC6C7C6);
  static const onTertiaryFixed = Color(0xFF1A1C1C);
  static const onTertiaryFixedVariant = Color(0xFF454747);
}
