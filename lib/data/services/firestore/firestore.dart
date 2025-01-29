import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference marks =
      FirebaseFirestore.instance.collection('marks');
  //CRUD
  Stream<QuerySnapshot> getMarks() {
    final marksStream = marks.orderBy('value', descending: true).snapshots();
    return marksStream;
  }
}

// services/firestore_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Отримати оцінки для конкретної групи
//   Future<List<Map<String, dynamic>>> fetchGrades(String groupId) async {
//     try {
//       final snapshot = await _firestore
//           .collection('groups')
//           .doc(groupId)
//           .collection('grades')
//           .get();

//       return snapshot.docs.map((doc) => doc.data()).toList();
//     } catch (e) {
//       throw Exception('Помилка при отриманні даних: $e');
//     }
//   }

//   fetchStudentData(String groupId, String studentEmail) {}
// }
