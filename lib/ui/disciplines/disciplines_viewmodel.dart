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
  int currentSemester = _getCurrentSemester();

  DisciplinesViewModel({required AuthViewModel authViewModel})
      : _firestoreService = FirestoreService(authViewModel: authViewModel);

  Future<void> fetchDisciplines() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allDisciplines = await _firestoreService.getGrades();

      disciplines = allDisciplines;

      filterDisciplinesBySemester(currentSemester);
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void filterDisciplinesBySemester(int semester) {
    filteredDisciplines = disciplines.where((discipline) {
      int? disciplineSemester = discipline['semester'];
      return disciplineSemester != null && disciplineSemester == semester;
    }).toList();

    notifyListeners();
  }

  static int _getCurrentSemester() {
    DateTime now = DateTime.now();
    int month = now.month;
    int year = now.year;

    int course = year - 2021; // Припустимо, що навчання почалося у 2021 році
    if (month >= 9) {
      return course * 2 - 1; // Вересень-грудень — непарний семестр
    } else {
      return course * 2; // Січень-червень — парний семестр
    }
  }
}
