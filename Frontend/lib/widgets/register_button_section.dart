import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterButtonSection extends StatelessWidget {
  final bool acceptTerms;
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final VoidCallback onAcceptTermsChanged;
  final VoidCallback onRegister;

  const RegisterButtonSection({
    Key? key,
    required this.acceptTerms,
    required this.isNameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.onAcceptTermsChanged,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isFormValid = isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid && acceptTerms;

    return Column(
      children: [
        // Terms and Conditions
        Row(
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: (value) => onAcceptTermsChanged(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.acceptTerms,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Register Button
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isFormValid
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Color.fromRGBO(
                        (Theme.of(context).colorScheme.primary.r * 255.0).round() & 0xff,
                        (Theme.of(context).colorScheme.primary.g * 255.0).round() & 0xff,
                        (Theme.of(context).colorScheme.primary.b * 255.0).round() & 0xff,
                        0.8,
                      ),
                    ],
                  )
                : null,
            boxShadow: isFormValid ? [
              BoxShadow(
                color: Color.fromRGBO(
                  (Theme.of(context).colorScheme.primary.r * 255.0).round() & 0xff,
                  (Theme.of(context).colorScheme.primary.g * 255.0).round() & 0xff,
                  (Theme.of(context).colorScheme.primary.b * 255.0).round() & 0xff,
                  0.3,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : onRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid
                  ? Colors.transparent
                  : Color.fromRGBO(
                      (Theme.of(context).colorScheme.primary.r * 255.0).round() & 0xff,
                      (Theme.of(context).colorScheme.primary.g * 255.0).round() & 0xff,
                      (Theme.of(context).colorScheme.primary.b * 255.0).round() & 0xff,
                      0.6,
                    ),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.createAccount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}