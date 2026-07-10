import 'package:flutter/material.dart';

/// Corner radius scale from DESIGN.md. [card] is a deliberate brand override
/// (24px) beyond the generic `lg` token, per DESIGN.md's "Shapes" section.
class AppRadius {
  AppRadius._();

  static const sm = 4.0;
  static const dflt = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const card = 24.0;
  static const full = 9999.0;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get dfltRadius => BorderRadius.circular(dflt);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
