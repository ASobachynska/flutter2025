import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  String get group => _extractGroup();
  int get currentCourse => _calculateCourse();

  UserProfileViewModel({required AuthService authService})
      : _authService = authService {
    _obtainUserDataFromService();
  }

  void _obtainUserDataFromService() {
    _currentUser = _authService.getCurrentUser();
  }

  String _extractGroup() {
    final email = _currentUser?.email ?? '';
    final groupPart = email.split('.').first;
    return groupPart.toUpperCase();
  }


int _calculateCourse() {
  final email = _currentUser?.email ?? '';
  final match = RegExp(r'(\d{2})').firstMatch(email);
  
  if (match == null) return 0;
  
  final admissionYear = int.parse('20${match.group(1)!}');
  final now = DateTime.now();
  
  // Обчислюємо поточний курс, але враховуємо, що до вересня поточного року студент залишається на старому курсі
  int course = now.year - admissionYear;
  if (now.month < 9) course--; // Зменшуємо курс, якщо до вересня місяця

  // Якщо зараз 2025 рік і місяць до вересня, студент ще на 4 курсі
  if (now.year == 2025 && now.month < 9) {
    course = 4;
  }

  return (course >= 1 && course <= 4) ? course : 4; // Обмеження для 4 курсів
}


  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _obtainUserDataFromService();
      notifyListeners();
    } catch (error) {
      print('Помилка при виході: $error');
    }
  }

  Future<void> launchURL() async {
    const url = 'https://cs.kpnu.edu.ua/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не вдалося відкрити $url';
    }
  }
}