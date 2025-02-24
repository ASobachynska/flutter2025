import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';
class GradesViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Map<String, dynamic>> grades = [];
  List<Map<String, dynamic>> filteredGrades = [];
  int selectedSemester;

  GradesViewModel({required AuthViewModel authViewModel})
      : _firestoreService = FirestoreService(authViewModel: authViewModel),
        selectedSemester = authViewModel.currentSemester {
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allGrades = await _firestoreService.getGrades();

      grades = allGrades
          .where((grade) => grade['semester'] != null) // Ensuring grades have a semester
          .toList();

      grades.sort((a, b) => (a['semester'] ?? 0).compareTo(b['semester'] ?? 0));

      filterGradesBySemester(selectedSemester);
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  List<int> get availableSemesters {
    var semesters = grades.map<int>((grade) => grade['semester'] as int).toSet().toList();
    if (!semesters.contains(8)) {
      semesters.add(8);  // Ensure 8th semester is available
    }
    semesters.sort();
    return semesters;
  }

  void setSelectedSemester(int semester) {
    selectedSemester = semester;
    filterGradesBySemester(semester);
    notifyListeners();
  }

  void filterGradesBySemester(int semester) {
    if (semester == -1) {
      filteredGrades = grades; // Show all semesters
    } else {
      filteredGrades = grades.where((grade) => grade['semester'] == semester).toList();
    }
    notifyListeners();
  }
}
