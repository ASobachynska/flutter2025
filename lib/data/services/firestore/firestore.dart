import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthViewModel _authViewModel;

  FirestoreService({required AuthViewModel authViewModel}) : _authViewModel = authViewModel;

  Future<DocumentSnapshot<Object?>?> getUserProfile() async {
    String? group = _authViewModel.group;
    String? email = _authViewModel.user?.email;

    if (group == null || email == null) {
      print("Group or email not available");
      return null;
    }

    try {
      String studentEmailFormatted = email.replaceAll('.', '_').replaceAll('@', '_');
      
// print("Fetching Firestore document: groups/$group/students_$group/$studentEmailFormatted");

DocumentSnapshot<Object?> studentDoc = await _db
    .collection('groups')
    .doc(group)
    .collection('students_$group')
    .doc(studentEmailFormatted)
    .get();

      if (!studentDoc.exists) {
        print('Document not found: $studentEmailFormatted');
        return null;
      }

      return studentDoc;
    } catch (e) {
      print('Error fetching student data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getGrades() async {
    DocumentSnapshot<Object?>? studentDoc = await getUserProfile();
    
    if (studentDoc == null || !studentDoc.exists) {
      throw Exception("Не вдалося отримати оцінки студента");
    }

    var data = studentDoc.data() as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['additionalRecords'] ?? []);
  }
}
