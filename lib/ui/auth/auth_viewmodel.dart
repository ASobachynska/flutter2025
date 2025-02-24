import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoggedIn = false;
  String? _errorMessage;
  String? _group;
  int? _course;
  String? _degree;

  AuthViewModel({required AuthService authService}) : _authService = authService {
    _checkLoginStatus();
  }

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  String? get group => _group;
  int? get course => _course;
  String? get degree => _degree;

  /// Визначає поточний семестр на основі курсу та місяця
  int get currentSemester {
    if (_course == null) return 1; // Якщо курс не визначено, повертаємо 1 семестр

    int currentMonth = DateTime.now().month;
    return (_course! - 1) * 2 + (currentMonth >= 9 ? 1 : 2);
  }

  void _parseEmail(String email) {
    final regex = RegExp(r'([a-zA-Z0-9]+)');
    final match = regex.firstMatch(email);

    if (match != null) {
      _group = match.group(0)?.toUpperCase();
      _group = _group!.replaceAllMapped(RegExp(r'([A-Z0-9]+)(B|M)'), (m) => '${m[1]}-${m[2]}');

      int year = int.parse(_group!.substring(_group!.length - 2));
      int currentYear = DateTime.now().year % 100;
      int currentMonth = DateTime.now().month;

      _course = (currentYear - year) + (currentMonth >= 9 ? 1 : 0);
      _degree = _group!.contains('M') ? 'Магістр' : 'Бакалавр';

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
    _degree = null;
    notifyListeners();
  }
}
