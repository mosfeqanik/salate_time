import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../data/models/selected_city.dart';

/// Bottom sheet listing the v1 hardcoded city list with local text
/// filtering (no geolocation / free city search — see docs/architecture.md).
Future<void> showCitySwitcherSheet({
  required BuildContext context,
  required SelectedCity selected,
  required ValueChanged<SelectedCity> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _CitySwitcherSheet(selected: selected, onSelect: onSelect),
  );
}

class _CitySwitcherSheet extends StatefulWidget {
  const _CitySwitcherSheet({required this.selected, required this.onSelect});

  final SelectedCity selected;
  final ValueChanged<SelectedCity> onSelect;

  @override
  State<_CitySwitcherSheet> createState() => _CitySwitcherSheetState();
}

class _CitySwitcherSheetState extends State<_CitySwitcherSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final results = AppConstants.availableCities
        .where((c) => c.displayLabel.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select city', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search city...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: scheme.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: AppRadius.mdRadius, borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final city = results[index];
                  final isSelected = city.id == widget.selected.id;
                  return ListTile(
                    title: Text(city.displayLabel, style: textTheme.bodyMedium),
                    trailing: isSelected ? Icon(Icons.check, color: scheme.primaryContainer) : null,
                    onTap: () {
                      widget.onSelect(city);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
