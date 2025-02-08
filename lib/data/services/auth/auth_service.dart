import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User?> signInWithGoogle() async {
    return kIsWeb ? await _webGoogleSignIn() : await _mobileGoogleSignIn();
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    user = null;
    _isLoggedIn = false;
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
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
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: "936391854887-5bj2sa89lsv0uartg8f7bh658m6rcmmv.apps.googleusercontent.com",
    ).signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final userCredentials = await _firebaseAuth.signInWithCredential(credentials);

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
    return email!.endsWith('@kpnu.edu.ua');
  }
  

  getCurrentUserEmail() {}
}
