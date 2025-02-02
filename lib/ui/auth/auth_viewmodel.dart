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
  String? _degree;  // Додано для визначення ступеня

  AuthViewModel({required AuthService authService}) : _authService = authService {
    _checkLoginStatus();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String? get group => _group;
  int? get course => _course;
  String? get degree => _degree;  // Гетер для ступеня (бакалавр чи магістр)

 void _parseEmail(String email) {
  final regex = RegExp(r'([a-zA-Z0-9]+)');  // Оновлений регулярний вираз для захоплення всієї групи
  final match = regex.firstMatch(email);

  if (match != null) {
    _group = match.group(0)?.toUpperCase();  // Група має бути повною (наприклад, kn1b21)

    int year = int.parse(_group!.substring(_group!.length - 2));  // Витягуємо останні два цифри для року
    int currentYear = DateTime.now().year % 100;
    int currentMonth = DateTime.now().month;

    if (currentMonth < 9) {
      _course = (currentYear - year);
    } else {
      _course = (currentYear - year) + 1;
    }

    // Перевіряємо наявність і "B", і "M"
    if (_group!.contains('B') && _group!.contains('M')) {
      _degree = 'Бакалавр';  // Якщо є і B, і M, виводимо "Бакалавр"
    } else if (_group!.contains('B')) {
      _degree = 'Бакалавр';
    } else if (_group!.contains('M')) {
      _degree = 'Магістр';
    } else {
      _degree = 'Невідомо';  // Якщо не визначено
    }

    notifyListeners();
  }
}


  Future<void> _checkLoginStatus() async {
    _user = _authService.getCurrentUser();
    _isLoggedIn = _user != null;
    if (_user != null) {
      _parseEmail(_user!.email!);  // Розбір пошти для визначення групи та ступеня
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
        _parseEmail(_user!.email!);  // Розбір пошти після логіну
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
    _degree = null;  // Скидаємо ступінь
    notifyListeners();
  }
}
