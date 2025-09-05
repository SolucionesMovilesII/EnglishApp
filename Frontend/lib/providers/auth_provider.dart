import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../l10n/app_localizations.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  
  AuthState _authState = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;
  
  AuthState get authState => _authState;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;
  
  AuthProvider() {
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        final userData = prefs.getString(_userKey);
        if (userData != null) {
          _user = UserModel.fromJson(userData);
          _authState = AuthState.authenticated;
        } else {
          _authState = AuthState.unauthenticated;
        }
      } else {
        _authState = AuthState.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = 'Error checking authentication status';
      notifyListeners();
    }
  }
  
  Future<void> checkAuthStatus(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        final userData = prefs.getString(_userKey);
        if (userData != null) {
          _user = UserModel.fromJson(userData);
          _authState = AuthState.authenticated;
        } else {
          _authState = AuthState.unauthenticated;
        }
      } else {
        _authState = AuthState.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = AppLocalizations.of(context)!.errorCheckingAuth;
      notifyListeners();
    }
  }
  
  Future<bool> login(BuildContext context, String email, String password) async {
    _setLoading(true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email.isEmpty || password.isEmpty) {
        throw Exception(AppLocalizations.of(context)!.emailPasswordRequired);
      }
      
      if (!_isValidEmail(email)) {
        throw Exception(AppLocalizations.of(context)!.emailInvalid);
      }
      
      if (password.length < 6) {
        throw Exception(AppLocalizations.of(context)!.passwordTooShort);
      }
      
      _user = UserModel(
        id: '1',
        name: 'Ximena',
        email: email,
        profileImage: null,
      );
      
      await _saveUserData();
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> loginWithGoogle(BuildContext context) async {
    _setLoading(true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _user = UserModel(
        id: '2',
        name: 'Ximena',
        email: 'ximena@gmail.com',
        profileImage: null,
      );
      
      await _saveUserData();
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = AppLocalizations.of(context)!.googleSignInFailed;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> loginWithApple(BuildContext context) async {
    _setLoading(true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _user = UserModel(
        id: '3',
        name: 'Ximena',
        email: 'ximena@icloud.com',
        profileImage: null,
      );
      
      await _saveUserData();
      _authState = AuthState.authenticated;
      _errorMessage = null;
      notifyListeners();
      
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = AppLocalizations.of(context)!.appleSignInFailed;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.setBool(_isLoggedInKey, false);
      
      _user = null;
      _authState = AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = AppLocalizations.of(context)!.errorDuringLogout;
      notifyListeners();
    }
  }
  
  void clearError() {
    _errorMessage = null;
    if (_authState == AuthState.error) {
      _authState = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  // Mock login method - always successful
  Future<void> mockLogin(BuildContext context) async {
    try {
      _setLoading(true);
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create mock user
      _user = UserModel(
        id: 'mock_user_123',
        name: 'Usuario Demo',
        email: 'demo@example.com',
      );
      
      _authState = AuthState.authenticated;
      _errorMessage = null;
      
      // Save user data
      await _saveUserData();
      
      notifyListeners();
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = AppLocalizations.of(context)!.errorInMockLogin;
      notifyListeners();
    }
  }
  
  void _setLoading(bool loading) {
    if (loading) {
      _authState = AuthState.loading;
      _errorMessage = null;
    }
    notifyListeners();
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  Future<void> _saveUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, _user!.toJson());
      await prefs.setBool(_isLoggedInKey, true);
    }
  }
}