import 'package:digital_department_app/routing/routes.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:digital_department_app/utils/constants/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<String> _routes = Routes.navigationMenuRoutes;
  void _onMenuItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Завжди показувати ярлики
        currentIndex: _currentIndex,
        onTap: _onMenuItemTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: UIConst.mainLabel),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: UIConst.scheduleLabel),
          BottomNavigationBarItem(
              icon: Icon(Icons.grade), label: UIConst.marksLabel),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: UIConst.disciplinesLabel),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: UIConst.userProfileLabel),
        ],
      ),
    );
  }
}
