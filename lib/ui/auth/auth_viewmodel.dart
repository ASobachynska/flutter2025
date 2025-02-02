import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoggedIn = false;
  String? _errorMessage;
  String? _group;
  int? _course;

  AuthViewModel({required AuthService authService}) : _authService = authService {
    _checkLoginStatus();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String? get group => _group;
  int? get course => _course;

  void _parseEmail(String email) {
    final regex = RegExp(r'([a-zA-Z]+\d+[bm]?)(\d{2})');
    final match = regex.firstMatch(email);

    if (match != null) {
      _group = match.group(1);
      int year = int.parse(match.group(2)!);
      int currentYear = DateTime.now().year % 100;
      _course = (currentYear - year) + 1;

      notifyListeners();
    }
  }

  Future<void> _checkLoginStatus() async {
    _user = _authService.getCurrentUser();
    _isLoggedIn = _user != null;
    if (_user != null) {
      _parseEmail(_user!.email!);
    }
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    try {
      _errorMessage = null;
      _user = await _authService.signInWithGoogle();

      if (_authService.error != null) {
        _errorMessage = _authService.error;
      } else if (_authService.isLoggedIn && _user != null) {
        _isLoggedIn = true;
        _parseEmail(_user!.email!);
      }

      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _isLoggedIn = false;
    _group = null;
    _course = null;
    notifyListeners();
  }
}

