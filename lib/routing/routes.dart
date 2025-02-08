abstract final class Routes {
  //app routes
  static const home = '/';
  static const login = '/login';
  static const userProfile = '/userProfile';
  static const grades = '/grades';
  // static const schedule = '/schedule';
  static const academicDisciplines = '/academicDisciplines';

  // navigation menu routes
  static const List<String> navigationMenuRoutes = [
    Routes.home,
    // Routes.schedule,
    Routes.grades,
    Routes.academicDisciplines,
    Routes.userProfile,
  ];
}
