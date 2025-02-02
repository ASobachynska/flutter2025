import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';

class UserProfileViewModel extends ChangeNotifier {
  final AuthService _authService;  // Сервіс для отримання даних користувача
  final AuthViewModel _authViewModel;  // Сервіс для отримання групи та курсу користувача
  User? _currentUser;  // Поточний користувач

  User? get currentUser => _currentUser;  // Getter для поточного користувача
  String get group => _authViewModel.group ?? '';  // Група користувача
  int get currentCourse => _authViewModel.course ?? 0;  // Курс користувача
  String get degree => _authViewModel.degree ?? '';  // Ступінь користувача (Бакалавр або Магістр)

  UserProfileViewModel({required AuthService authService, required AuthViewModel authViewModel})
      : _authService = authService,
        _authViewModel = authViewModel {
    _obtainUserDataFromService();  // Отримання даних про користувача
  }

  // Отримуємо поточного користувача
  void _obtainUserDataFromService() {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();  // Оновлення UI
  }

  // Вихід з акаунта
  Future<void> signOut() async {
    try {
      await _authService.signOut();  // Вихід
      _obtainUserDataFromService();  // Оновлення даних
      notifyListeners();  // Оновлення UI
    } catch (error) {
      print('Помилка при виході: $error');  // Логування помилки
    }
  }

  Future<void> launchURL() async {
    const url = 'https://cs.kpnu.edu.ua/';
    if (await canLaunch(url)) { 
      await launch(url);  // Відкриває сайт
    } else {
      throw 'Не вдалося відкрити $url';
    }
  }
}
