// Цей файл відповідає за маршрутизацію в digital-department-app і
// використовує GoRouter для керування навігацією
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';
import 'package:digital_department_app/ui/auth/auth_screen.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:digital_department_app/ui/core/ui/navigation_menu/navigation_menu.dart';
import 'package:digital_department_app/ui/disciplines/disciplines_screen.dart';
import 'package:digital_department_app/ui/disciplines/disciplines_viewmodel.dart';
import 'package:digital_department_app/ui/grades/grades_screen.dart';
import 'package:digital_department_app/ui/grades/grades_viewmodel.dart';
import 'package:digital_department_app/ui/home/widgets/home_screen.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_screen.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_viewmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'routes.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();
// Ключ для навігації в ShellRoute, щоб правильно обробляти дочірні маршрути

GoRouter router(AuthService authService) {
  return GoRouter(
    initialLocation: // initialLocation перевіряє, чи користувач авторизований
        authService.checkAuthorizedStatus()
            ? Routes.home
            : Routes
                .login, // Якщо так → переходить на Routes.home | Якщо ні → відкриває Routes.login.
    // redirect: (context, state) {
    //   if (authService.checkAuthorizedStatus()) {
    //     return Routes.home;
    //   } else {
    //     return Routes.login;
    //   }
    // },
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
          // Головний навігаційний контейнер (з MainNavigation)
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MainNavigation(
                child: child,
              ),
// Це дозволяє змінювати екрани без повторного створення BottomNavigationBar
          routes: [
            GoRoute(
              // HomeScreen()
              parentNavigatorKey: _shellNavigatorKey,
              path: Routes.home,
              name: 'home',
              builder: (context, state) {
                return HomeScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: Routes.userProfile,
              name: 'userProfile',
              builder: (context, state) {
                return UserProfileScreen(
                  viewModel: context.read<UserProfileViewModel>(),
                );
              },
            ),

// GoRoute(
//               parentNavigatorKey: _shellNavigatorKey,
//               path: Routes.userProfile,
//               name: 'userProfile',
//               builder: (context, state) {
//                 return UserProfileScreen(
//                   viewModel: UserProfileViewModel(
//                     authService: context.read<AuthService>(),
//                     authViewModel:
//                         context.read<AuthViewModel>(), // Додаємо authViewModel
//                     firestoreService: context
//                         .read<FirestoreService>(), // Додаємо firestoreService
//                   ),
//                 );
//               },
//             ),

            // GoRoute( // SchedulePage()
            //   parentNavigatorKey: _shellNavigatorKey,
            //   path: Routes.schedule,
            //   name: 'schedule',
            //   builder: (context, state) {
            //     return SchedulePage();
            //   },
            // ),
            GoRoute(
              // DisciplinesPage()
              parentNavigatorKey: _shellNavigatorKey,
              path: Routes.academicDisciplines,
              name: 'academicDisciplines',
              builder: (context, state) {
                return DisciplinesPage(); //TODO: replace with viewModel and service constructor
              },
            ),
            GoRoute(
              // CurrentGradesPage()
              parentNavigatorKey: _shellNavigatorKey,
              path: Routes.grades,
              name: 'grades',
              builder: (context, state) {
                return CurrentGradesPage(); //TODO: replace with viewModel and service constructor
              },
            ),
          ]),
      GoRoute(
        // AuthScreen()
        path: Routes.login,
        name: 'login',
        builder: (context, state) {
          return AuthScreen(
            viewModel: AuthViewModel(authService: context.read()),
          );
          // AuthScreen отримує AuthViewModel, який керує автентифікацією
        },
      ),
    ],
  );
}
