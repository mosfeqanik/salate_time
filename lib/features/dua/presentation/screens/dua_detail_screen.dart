import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/dua.dart';

/// Shows a single dua with its Arabic text, transliteration, translation,
/// and source reference. Pushed from [DuaListScreen].
class DuaDetailScreen extends StatelessWidget {
  const DuaDetailScreen({super.key, required this.dua});

  final Dua dua;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(dua.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            // Arabic text
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.08),
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: scheme.primaryContainer.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                dua.arabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: textTheme.headlineMedium?.copyWith(
                  color: scheme.primary,
                  height: 2.0,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Transliteration
            _SectionCard(
              label: 'Transliteration',
              child: Text(
                dua.transliteration,
                style: textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Translation
            _SectionCard(
              label: 'Translation',
              child: Text(dua.translation, style: textTheme.bodyLarge),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Reference
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 18, color: scheme.secondary),
                  const SizedBox(width: AppSpacing.base),
                  Expanded(
                    child: Text(
                      dua.reference,
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: scheme.secondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          child,
        ],
      ),
    );
  }
}