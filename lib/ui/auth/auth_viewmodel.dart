import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required AuthService authService,
  }) : _authService = AuthService() {
    _checkAuthorizedStatus();
    print('AUTH Service created');
  }
  final AuthService _authService;

  User? _user;
  bool _isLoggedIn = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  Future<void> loginWithGoogle() async {
    print('Login function in vm called');
    try {
      _errorMessage = null;
      _user = await _authService.signInWithGoogle();
      if (_authService.error != null) {
        _errorMessage = _authService.error;
        notifyListeners();
      }
      if (_authService.isLoggedIn) {
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      print("Error during login: $error");
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }

  void _checkAuthorizedStatus() {
    _isLoggedIn = _authService.checkAuthorizedStatus();
    print('Auth checks status: $_isLoggedIn');
    notifyListeners();
  }
}
