import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid; // унікальний ідентифікатор користувача в Firebase.
  final String email;
  final String displayName;
  final String? photoURL; // (може бути null)

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
  });

// Метод fromFirebaseUser(User user) створює об'єкт UserModel з Firebase-користувача, 
//щоб спростити доступ до його даних
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'No name',
      photoURL: user.photoURL ?? 'no photo',
    );
  }
}
