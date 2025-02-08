import 'package:digital_department_app/config/firebase_options.dart';
import 'package:digital_department_app/config/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(appProviders(const MyApp())); // Використовуємо функцію з providers.dart
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Digital Department App',
      themeMode: ThemeMode.system,
      routerConfig: router(context.read()),
    );
  }
}
