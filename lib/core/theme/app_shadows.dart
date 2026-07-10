import 'package:flutter/material.dart';

/// "Sunken shadow" presets from DESIGN.md: wide, low-opacity, soft — never a
/// harsh drop shadow.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sunken = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 10),
      blurRadius: 20,
    ),
  ];
}
