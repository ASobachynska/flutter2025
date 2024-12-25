import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  String? _errorMessage;
  User? _currentUser;

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

  Future<void> signOut() async {
    try {
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
  }
}
