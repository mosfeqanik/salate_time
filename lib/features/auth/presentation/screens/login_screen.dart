import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_code_input_field.dart';
import '../widgets/phone_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submitPhone(AuthProvider auth) {
    final phone = _phoneController.text.trim();
    if (phone.length < 11) {
      setState(() => _validationError = 'Please enter a valid phone number');
      return;
    }
    setState(() => _validationError = null);
    auth.sendOtp(phone);
  }

  void _submitCode(AuthProvider auth) {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _validationError = 'Please enter the code you received');
      return;
    }
    setState(() => _validationError = null);
    auth.verifyOtp(code);
  }

  void _changeNumber(AuthProvider auth) {
    _codeController.clear();
    setState(() => _validationError = null);
    auth.backToPhoneEntry();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final auth = context.watch<AuthProvider>();
    final isCodeStep = auth.loginStep == LoginStep.enterCode;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(scheme: scheme),
                  Text(
                    'SalatTime',
                    style: textTheme.displayLarge?.copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (isCodeStep)
                    _OtpCard(
                      scheme: scheme,
                      textTheme: textTheme,
                      auth: auth,
                      codeController: _codeController,
                      validationError: _validationError,
                      onVerify: () => _submitCode(auth),
                      onResend: () => auth.resendOtp(),
                      onChangeNumber: () => _changeNumber(auth),
                    )
                  else
                    _LoginCard(
                      scheme: scheme,
                      textTheme: textTheme,
                      auth: auth,
                      phoneController: _phoneController,
                      validationError: _validationError,
                      onSubmit: () => _submitPhone(auth),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'By continuing, you agree to our Terms of Service',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
      child: Icon(Icons.mosque, color: scheme.onPrimaryContainer, size: 32),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.scheme,
    required this.textTheme,
    required this.auth,
    required this.phoneController,
    required this.validationError,
    required this.onSubmit,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;
  final AuthProvider auth;
  final TextEditingController phoneController;
  final String? validationError;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      scheme: scheme,
      children: [
        PhoneInputField(controller: phoneController, errorText: validationError),
        if (auth.errorMessage != null) _ErrorText(message: auth.errorMessage!, textTheme: textTheme, scheme: scheme),
        const SizedBox(height: AppSpacing.sm),
        _SubmitButton(isSubmitting: auth.isSubmitting, onPressed: onSubmit, label: 'Send OTP'),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _OtpCard extends StatelessWidget {
  const _OtpCard({
    required this.scheme,
    required this.textTheme,
    required this.auth,
    required this.codeController,
    required this.validationError,
    required this.onVerify,
    required this.onResend,
    required this.onChangeNumber,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;
  final AuthProvider auth;
  final TextEditingController codeController;
  final String? validationError;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangeNumber;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      scheme: scheme,
      children: [
        Text(
          'Code sent to ${auth.pendingPhoneNumber ?? ''}',
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        OtpCodeInputField(controller: codeController, errorText: validationError),
        if (auth.errorMessage != null) _ErrorText(message: auth.errorMessage!, textTheme: textTheme, scheme: scheme),
        const SizedBox(height: AppSpacing.sm),
        _SubmitButton(isSubmitting: auth.isSubmitting, onPressed: onVerify, label: 'Verify'),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: auth.isSubmitting ? null : onChangeNumber,
              child: const Text('Change number'),
            ),
            TextButton(
              onPressed: auth.isSubmitting ? null : onResend,
              child: const Text('Resend code'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.scheme, required this.children});

  final ColorScheme scheme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppShadows.sunken,
      ),
      child: Column(children: children),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message, required this.textTheme, required this.scheme});

  final String message;
  final TextTheme textTheme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        message,
        style: textTheme.labelSmall?.copyWith(color: scheme.error),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.isSubmitting, required this.onPressed, required this.label});

  final bool isSubmitting;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}
