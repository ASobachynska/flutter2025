import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GradesViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Map<String, dynamic>> grades = [];

  Future<void> fetchGrades() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await _firestore.collection('grades').get();

      grades = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      isLoading = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
