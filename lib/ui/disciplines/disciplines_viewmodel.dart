import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';

class DisciplinesViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Map<String, dynamic>> disciplines = [];
  List<Map<String, dynamic>> filteredDisciplines = [];
  int selectedYear = 4; // За замовчуванням 4-й курс

  DisciplinesViewModel({required AuthViewModel authViewModel})
      : _firestoreService = FirestoreService(authViewModel: authViewModel);

  Future<void> fetchDisciplines() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allDisciplines = await _firestoreService.getGrades();

      // Всі дисципліни без фільтрації за оцінками
      disciplines = allDisciplines;

      // Фільтрація за вибраним роком
      filterDisciplinesByYear(selectedYear);
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void filterDisciplinesByYear(int year) {
    selectedYear = year;
    int semesterStart = (year - 1) * 2 + 1;
    int semesterEnd = semesterStart + 1;

    filteredDisciplines = disciplines.where((discipline) {
      int? semester = discipline['semester'];
      return semester != null && semester >= semesterStart && semester <= semesterEnd;
    }).toList();

    notifyListeners();
  }
}
