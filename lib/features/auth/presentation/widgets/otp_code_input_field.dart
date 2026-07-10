import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';

/// OTP code entry field. Mirrors [PhoneInputField]'s styling minus the
/// country-code chip. No fixed length is enforced — the real OTP length
/// wasn't confirmed by the backend, so validation only requires non-empty.
class OtpCodeInputField extends StatelessWidget {
  const OtpCodeInputField({super.key, required this.controller, this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VERIFICATION CODE', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: AppRadius.mdRadius,
            border: Border.all(
              color: errorText != null ? scheme.error : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Enter the code you received',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.error),
          ),
        ],
      ],
    );
  }
}
