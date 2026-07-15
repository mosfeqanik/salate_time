import 'package:flutter/material.dart';

import '../../data/models/calculation_method.dart';

/// Bottom sheet listing the supported prayer-time calculation methods,
/// mirroring [showCitySwitcherSheet]'s layout.
Future<void> showCalculationMethodSheet({
  required BuildContext context,
  required CalculationMethod selected,
  required ValueChanged<CalculationMethod> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) =>
        _CalculationMethodSheet(selected: selected, onSelect: onSelect),
  );
}

class _CalculationMethodSheet extends StatelessWidget {
  const _CalculationMethodSheet({
    required this.selected,
    required this.onSelect,
  });

  final CalculationMethod selected;
  final ValueChanged<CalculationMethod> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation method',
              style: textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: CalculationMethod.all.length,
                itemBuilder: (context, index) {
                  final method = CalculationMethod.all[index];
                  final isSelected = method.id == selected.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(method.label, style: textTheme.bodyMedium),
                    trailing: isSelected
                        ? Icon(Icons.check, color: scheme.primaryContainer)
                        : null,
                    onTap: () {
                      onSelect(method);
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
