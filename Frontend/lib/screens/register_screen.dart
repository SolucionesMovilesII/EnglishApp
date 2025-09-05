import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/auth_provider.dart';
import '../widgets/settings_button.dart';
import '../widgets/app_banner.dart';
import '../widgets/register_form_fields.dart';
import '../widgets/register_button_section.dart';
import '../widgets/social_register_section.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'loading_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  void _validateName() {
    final name = _nameController.text;
    setState(() {
      _isNameValid = name.isNotEmpty && name.length >= 2;
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _isEmailValid = email.isNotEmpty && 
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    });
  }
  
  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.isNotEmpty && password.length >= 6;
    });
    _validateConfirmPassword(); // Re-validate confirm password
  }
  
  void _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      _isConfirmPasswordValid = confirmPassword.isNotEmpty && 
          confirmPassword == _passwordController.text;
    });
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      
                      // App Banner
                      AppBanner(
                        title: AppLocalizations.of(context)!.appTitle,
                        livesText: AppLocalizations.of(context)!.livesRemaining,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Welcome Text
                      Text(
                        AppLocalizations.of(context)!.createAccount,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        AppLocalizations.of(context)!.joinUsSlogan,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Registration Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Form Fields
                            RegisterFormFields(
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmPasswordController: _confirmPasswordController,
                              isNameValid: _isNameValid,
                              isEmailValid: _isEmailValid,
                              isPasswordValid: _isPasswordValid,
                              isConfirmPasswordValid: _isConfirmPasswordValid,
                              obscurePassword: _obscurePassword,
                              obscureConfirmPassword: _obscureConfirmPassword,
                              onTogglePasswordVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              onToggleConfirmPasswordVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Register Button Section
                            RegisterButtonSection(
                              acceptTerms: _acceptTerms,
                              isNameValid: _isNameValid,
                              isEmailValid: _isEmailValid,
                              isPasswordValid: _isPasswordValid,
                              isConfirmPasswordValid: _isConfirmPasswordValid,
                              onAcceptTermsChanged: () {
                                setState(() {
                                  _acceptTerms = !_acceptTerms;
                                });
                              },
                              onRegister: _handleRegister,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Social Register Section
                            SocialRegisterSection(
                              onGoogleRegister: _handleGoogleRegister,
                              onAppleRegister: _handleAppleRegister,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.alreadyHaveAccount,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Settings Button
            const SettingsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SvgPicture.asset(
      'assets/icons/google_icon.svg',
      width: 24,
      height: 24,
    );
  }

  Widget _buildAppleIcon() {
    return SvgPicture.asset(
      'assets/icons/apple_icon.svg',
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseAcceptTerms),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Show loading screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            message: AppLocalizations.of(context)!.creatingAccount,
            duration: const Duration(seconds: 3),
            onLoadingComplete: () => _completeRegistration(),
          ),
        ),
      );
    }
  }

  void _completeRegistration() {
    if (mounted) {
      // Mock registration - always successful
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.mockLogin(context); // This will set user as authenticated
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _handleGoogleRegister() async {
    // Show loading screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          message: AppLocalizations.of(context)!.creatingAccountWithGoogle,
          duration: const Duration(seconds: 3),
          onLoadingComplete: () => _completeRegistration(),
        ),
      ),
    );
  }

  Future<void> _handleAppleRegister() async {
    // Show loading screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          message: AppLocalizations.of(context)!.creatingAccountWithApple,
          duration: const Duration(seconds: 3),
          onLoadingComplete: () => _completeRegistration(),
        ),
      ),
    );
  }
}