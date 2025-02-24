import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  User? user;
  String? _error;
  bool _authInProgress = false; // Запобігає конфліктам викликів

  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  AuthService() {
    _firebaseAuth.setLanguageCode('uk');
    getCurrentUser();
  }

  Future<User?> signInWithGoogle() async {
    if (_authInProgress) return null;
    _authInProgress = true;

    final result = kIsWeb ? await _webGoogleSignIn() : await _mobileGoogleSignIn();

    _authInProgress = false;
    return result;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    user = null;
    _isLoggedIn = false;
  }

  User? getCurrentUser() {
    user = _firebaseAuth.currentUser;
    return user;
  }
  
  bool checkAuthorizedStatus() {
    final currentUser = getCurrentUser();
    _isLoggedIn = currentUser != null;
    return _isLoggedIn;
  }

  Future<User?> _webGoogleSignIn() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      final UserCredential userCredential =
          await _firebaseAuth.signInWithPopup(googleProvider);

      if (userCredential.user == null) {
        return null;
      }

      if (!_verifyEmailDomain(userCredential.user?.email)) {
        await signOut();
        throw Exception('Invalid email domain. Only @kpnu.edu.ua allowed');
      }

      _isLoggedIn = true;
      return userCredential.user;
    } catch (error) {
      debugPrint("Error: $error");
      return null;
    }
  }
  
  Future<User?> _mobileGoogleSignIn() async {
    _error = null;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: "936391854887-5bj2sa89lsv0uartg8f7bh658m6rcmmv.apps.googleusercontent.com",
      ).signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, 
        idToken: googleAuth.idToken
      );

      final userCredentials = await _firebaseAuth.signInWithCredential(credentials);

      if (userCredentials.user?.email == null) {
        throw Exception('Email not found');
      }

      if (_verifyEmailDomain(userCredentials.user!.email)) {
        _isLoggedIn = true;
        _error = null;
        return userCredentials.user;
      } else {
        await signOut();
        throw Exception('Invalid email domain. Only @kpnu.edu.ua allowed');
      }
    } on FirebaseAuthException catch (e) {
      _error = 'Firebase Auth Error: ${e.message}';
      debugPrint(_error);
      rethrow;
    } catch (error) {
      _error = 'Unexpected error: $error';
      debugPrint(_error);
      rethrow;
    }
  }

  bool _verifyEmailDomain(String? email) {
    return email?.endsWith('@kpnu.edu.ua') ?? false;
  }
  
  getCurrentUserEmail() {}
}