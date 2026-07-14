import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/dua_repository.dart';
import '../../data/models/dua.dart';
import 'dua_detail_screen.dart';

/// The Dua tab: a sectioned list of duas grouped by category. Tapping a row
/// pushes [DuaDetailScreen] for the full Arabic, transliteration, and
/// translation.
class DuaListScreen extends StatelessWidget {
  const DuaListScreen({super.key});

  static const _repository = DuaRepository();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categories = _repository.categories();

    return Scaffold(
      appBar: AppBar(title: const Text('Dua')),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final duas = _repository.byCategory(category);
            return _CategorySection(
              category: category,
              duas: duas,
              scheme: scheme,
              textTheme: textTheme,
            );
          },
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.duas,
    required this.scheme,
    required this.textTheme,
  });

  final String category;
  final List<Dua> duas;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              0,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Text(
              category.toUpperCase(),
              style: textTheme.labelLarge?.copyWith(
                color: scheme.secondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < duas.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _DuaTile(dua: duas[i], scheme: scheme, textTheme: textTheme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaTile extends StatelessWidget {
  const _DuaTile({
    required this.dua,
    required this.scheme,
    required this.textTheme,
  });

  final Dua dua;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.menu_book_outlined, color: scheme.primaryContainer),
      title: Text(dua.title, style: textTheme.bodyLarge),
      subtitle: Text(
        dua.translation,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: Icon(Icons.chevron_right, color: scheme.outline),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DuaDetailScreen(dua: dua),
        ),
      ),
    );
  }
}