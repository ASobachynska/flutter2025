// Модель представлення (ViewModel) для екрану профілю, яка працює з 
// AuthService для отримання даних про користувача та виходу з акаунту
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final AuthService _authService; // взаємодіє з Firebase Auth через AuthService
  String? _errorMessage; // містить текст помилки, якщо вихід не вдався
  User? _currentUser; // зберігає поточного користувача

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  UserProfileViewModel({required AuthService authService})
      : _authService = authService {
    _obtainUserDataFromService();
    print("User: $currentUser");
  }

  void _obtainUserDataFromService() {
    _currentUser = _authService.getCurrentUser();
  }
// отримує поточного користувача через _authService.getCurrentUser(); 
// (але не викликає notifyListeners() після оновлення).

  Future<void> signOut() async {
    try { // вихід з акаунту через _authService.signOut();, після чого оновлює _currentUser
      await _authService.signOut();
      _obtainUserDataFromService();
      if (_currentUser == null) {
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Помилка при виході: $error')),
      //   );
      // }
    }
  }

  Future<void> launchURL() async {
    const url = 'https://cs.kpnu.edu.ua/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    // ! відкриває сайт через url_launcher, але використовує застарілі методи canLaunch() і launch()
  }
}
