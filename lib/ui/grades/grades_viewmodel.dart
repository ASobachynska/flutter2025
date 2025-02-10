import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';

class GradesViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Map<String, dynamic>> grades = [];

  GradesViewModel({required AuthViewModel authViewModel})
      : _firestoreService = FirestoreService(authViewModel: authViewModel);

  Future<void> fetchGrades() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      List<Map<String, dynamic>> allGrades = await _firestoreService.getGrades();

      // Фільтруємо лише записи, де grade має значення
      grades = allGrades
          .where((grade) => grade['grade'] != null && grade['grade'].toString().isNotEmpty)
          .toList();

      // Сортуємо дисципліни за полем 'semester' або 'date' (за зростанням)
      grades.sort((b, a) {
        // Якщо є поле 'semester', сортуємо за ним
        var semesterA = a['semester'];
        var semesterB = b['semester'];

        // Якщо поле 'semester' відсутнє, можна використовувати поле 'date'
        var dateA = a['year'];
        var dateB = b['year'];

        // Використовуємо тернарний оператор для вибору поля сортування
        if (semesterA != null && semesterB != null) {
          return semesterA.compareTo(semesterB);
        } else if (dateA != null && dateB != null) {
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        }

        // Якщо немає жодного з полів, то не сортуємо
        return 0;
      });
      
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
