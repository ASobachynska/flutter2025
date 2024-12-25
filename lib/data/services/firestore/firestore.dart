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
