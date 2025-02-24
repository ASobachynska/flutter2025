// import 'package:googleapis/drive/v3.dart';
// import 'package:googleapis_auth/googleapis_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:googleapis/googleapis.dart' as googleapis;

// class GoogleDriveService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
//   Future<DriveApi> _getDriveApi() async {
//     final user = _firebaseAuth.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final authClient = await _getAuthClient(user);
//     return DriveApi(authClient);
//   }

//   Future<AutoRefreshingAuthClient> _getAuthClient(User user) async {
//     final credentials = await user.getIdToken();
//     final client = await clientViaUserConsent(
//       ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET'),
//       [DriveApi.DriveScope],
//       (url) {
//         // TODO: open this URL to authorize user
//       },
//     );
//     return client;
//   }

//   Future<List<File>> getImages() async {
//     final driveApi = await _getDriveApi();
//     final fileList = await driveApi.files.list(q: "mimeType='image/jpeg'");
//     return fileList.files!;
//   }
// }
