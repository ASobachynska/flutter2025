// Це модель представлення (ViewModel), яка керує логікою авторизації
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required AuthService authService,
  }) : _authService = AuthService() { // приватний екземпляр AuthService
    _checkAuthorizedStatus();
  }
  final AuthService _authService;

  User? _user; // зберігає поточного користувача (User?)
  bool _isLoggedIn = false; // прапорець входу (true/false)
  String? _errorMessage; // зберігає текст помилки (якщо є)

  User? get user => _user; // повертає _user
  bool get isLoggedIn => _isLoggedIn; // повертає _isLoggedIn
  String? get errorMessage => _errorMessage; // повертає _errorMessage

  Future<void> loginWithGoogle() async {
    try {
      _errorMessage = null;
      _user = await _authService.signInWithGoogle(); // Викликає signInWithGoogle() у AuthService
      if (_authService.error != null) {
        _errorMessage = _authService.error;
        notifyListeners(); // Якщо AuthService повертає помилку → зберігає її у _errorMessage
      }
      if (_authService.isLoggedIn) {
        _isLoggedIn = true;
        notifyListeners(); // Якщо авторизація успішна → змінює _isLoggedIn на true
      }
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isLoggedIn = false;
    notifyListeners();
  } // Викликає signOut() у AuthService, очищає _isLoggedIn, повідомляє UI

  void _checkAuthorizedStatus() {
    _isLoggedIn = _authService.checkAuthorizedStatus();
    notifyListeners();
  } // Перевіряє, чи користувач вже увійшов, і оновлює _isLoggedIn
}
