import 'package:digital_department_app/config/firebase_options.dart';
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:digital_department_app/routing/router.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (context) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
              authService: context
                  .read()), //TODO: redefine MultiProvider in separate file after main flow implementation 
                            //TODO: перевизначте MultiProvider в окремому файлі після реалізації основного потоку
        ),
        ChangeNotifierProvider(
          create: (context) =>
              UserProfileViewModel(authService: context.read()),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Digital Department App',
      //home: SignInScreen(),
      // theme: lightTheme,    // TODO: Uncomment this lines after themes files updated corresponds PDD
      // darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router(context.read()),
    );
  }
}
