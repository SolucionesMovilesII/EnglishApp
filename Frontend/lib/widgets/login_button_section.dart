import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginButtonSection extends StatelessWidget {
  final bool isEmailValid;
  final bool isPasswordValid;
  final VoidCallback onLoginPressed;

  const LoginButtonSection({
    super.key,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            // Error Message
            if (authProvider.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  authProvider.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Login Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: (isEmailValid && isPasswordValid)
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
                boxShadow: (isEmailValid && isPasswordValid) ? [
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
                onPressed: authProvider.isLoading ? null : onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isEmailValid && isPasswordValid)
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
                        AppLocalizations.of(context)!.loginButton,
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
      },
    );
  }
}