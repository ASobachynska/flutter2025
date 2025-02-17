import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';

class UserProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final AuthViewModel _authViewModel;
  final FirestoreService _firestoreService;

  User? _currentUser;
  DocumentSnapshot? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String get group => _authViewModel.group ?? 'Невідома група';
  int get currentCourse => _authViewModel.course ?? 0;
  String get degree => _authViewModel.degree ?? 'Невідомий ступінь';
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  String get studentName => _userProfile?['student_name'] ?? 'Невідомо';
  String get email => _currentUser?.email ?? 'Не вдалося отримати email';

  final List<Map<String, String>> usefulLinks = [
    {
      'title': 'Фізико-математичний факультет',
      'url': 'https://fizmat.kpnu.edu.ua/',
    },
    {
      'title': 'Кафедра комп\'ютерних наук',
      'url': 'https://cs.kpnu.edu.ua/',
    },
    {
      'title': 'Розклад занять',
      'url': 'https://kpnu.edu.ua/rozklad-zaniat/',
    },
  ];

  UserProfileViewModel({
    required AuthService authService,
    required AuthViewModel authViewModel,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _authViewModel = authViewModel,
        _firestoreService = firestoreService {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _currentUser = _authService.getCurrentUser();
      if (_currentUser != null && _currentUser!.uid.isNotEmpty) {
        _isLoading = true;
        notifyListeners();

        DocumentSnapshot? snapshot = await _firestoreService.getUserProfile();

        if (snapshot != null) {
          _userProfile = snapshot;
        } else {
          _errorMessage = "Не вдалося знайти профіль студента";
        }
      } else {
        _errorMessage = "Користувач не знайдений або UID порожній";
      }
    } catch (e) {
      _errorMessage = "Помилка при отриманні даних: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
