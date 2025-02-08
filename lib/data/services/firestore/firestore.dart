import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthViewModel _authViewModel;

  FirestoreService({required AuthViewModel authViewModel}) : _authViewModel = authViewModel;

  // Define the getUserProfile method to return a DocumentSnapshot
  Future<DocumentSnapshot?> getUserProfile(String uid) async {
    String? group = _authViewModel.group;
    String? email = _authViewModel.user?.email;

    if (group == null || email == null) {
      print("Group or email not available");
      return null;
    }

    try {
      String studentEmailFormatted = email.replaceAll('.', '_').replaceAll('@', '_');
      DocumentSnapshot studentDoc = await _db
          .collection('groups')
          .doc(group)
          .collection('students_$group')
          .doc(studentEmailFormatted)
          .get();

      if (!studentDoc.exists) {
        print('Document not found: $studentEmailFormatted');
        return null;
      }

      print('Student Data: ${studentDoc.data()}');
      return studentDoc;
    } catch (e) {
      print('Error fetching student data: $e');
      return null;
    }
  }
}
