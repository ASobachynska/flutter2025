// Цей файл відповідає за маршрутизацію в digital-department-app і
// використовує GoRouter для керування навігацією
import 'package:digital_department_app/data/services/auth/auth_service.dart';
import 'package:digital_department_app/ui/auth/auth_screen.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:digital_department_app/ui/core/ui/navigation_menu/navigation_menu.dart';
import 'package:digital_department_app/ui/disciplines/disciplines_screen.dart';
import 'package:digital_department_app/ui/grades/grades_screen.dart';
import 'package:digital_department_app/ui/home/widgets/home_screen.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_screen.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_viewmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:digital_department_app/ui/grades/grades_viewmodel.dart';
import 'package:digital_department_app/ui/disciplines/disciplines_viewmodel.dart';


final _shellNavigatorKey = GlobalKey<NavigatorState>();
// Ключ для навігації в ShellRoute, щоб правильно обробляти дочірні маршрути
GoRouter router(AuthService authService) {
  return GoRouter(
    initialLocation: authService.checkAuthorizedStatus()
        ? Routes.home
        : Routes.login, 
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
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
          GoRoute(
      path: Routes.academicDisciplines,
      builder: (context, state) {
        final authViewModel = context.read<AuthViewModel>();
        return ChangeNotifierProvider(
          create: (_) => DisciplinesViewModel(authViewModel: authViewModel)
            ..fetchDisciplines(),
          child: DisciplinesPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.grades,
      builder: (context, state) {
        final authViewModel = context.read<AuthViewModel>();
        return ChangeNotifierProvider(
          create: (_) => GradesViewModel(authViewModel: authViewModel)
            ..fetchGrades(),
          child: CurrentGradesPage(),
        );
      },
    ),
        ],
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) {
          return AuthScreen(
            viewModel: AuthViewModel(authService: context.read()),
          );
        },
      ),
    ],
  );
}