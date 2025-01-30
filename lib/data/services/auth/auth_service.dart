import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// сервіс AuthService відповідає за аутентифікацію користувача в додатку
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  User? user;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  AuthService() {
    _firebaseAuth.setLanguageCode('uk');
    getCurrentUser();
  }

  // Sign in with google account
  Future<User?> signInWithGoogle() async {
    return kIsWeb ? await _webGoogleSignIn() : await _mobileGoogleSignIn();
  }

  // Sign out method
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    user = null;
    _isLoggedIn = false;
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
  
  // перевіряє, чи користувач увійшов в систему
  bool checkAuthorizedStatus() {
    if (getCurrentUser() != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    return _isLoggedIn;
  }

  Future<User?> _webGoogleSignIn() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _firebaseAuth.signInWithPopup(googleProvider);
      _isLoggedIn = true;
      return userCredential.user;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<User?> _mobileGoogleSignIn() async {
    _error = null;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredentials =
          await _firebaseAuth.signInWithCredential(credentials);
      if (_verifyEmailDomain(userCredentials.user!.email)) {
        _isLoggedIn = true;
        _error = null;
        return userCredentials.user;
      } else {
        await signOut();
        throw Exception('Invalid email domain. Available @kpnu.edu.ua only');
      }
    } catch (error) {
      _error = error.toString();
      rethrow;
    }
  }

  bool _verifyEmailDomain(String? email) {
    return email!.endsWith('@kpnu.edu.ua');
  }

  getCurrentUserEmail() {}
}
