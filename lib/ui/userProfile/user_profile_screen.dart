import 'package:digital_department_app/routing/routes.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.viewModel});

  final UserProfileViewModel viewModel;
  // UserProfileViewModel для отримання поточного користувача
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onSignOutResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/profile3.png'), // Background image path
                fit: BoxFit.cover, // Image covers entire screen
              ),
            ),
          ),
          // Main content
          Center(
            child: Transform.translate(
              offset: const Offset(0, 10), // Top margin
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Center content based on its size
                  children: [
                    // Profile circle with shadow
                    Container(
                      width: 120, // Container size
                      height: 120,
                      decoration: BoxDecoration(
                        shape:
                            BoxShape.circle, // Ensures the shadow is circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 4), // Shadow specifically below
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60, // Avatar size
                        backgroundColor: Colors.white, // Avatar background
                        child: Icon(
                          Icons.person, // Default profile icon
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.viewModel.currentUser?.displayName ??
                                'Can not userName',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Група kn1b21          4 Курс          Бакалавр',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '122 Комп\'ютерні науки та інформаційні технології',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.viewModel.currentUser?.email ??
                                "Can't get email",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.viewModel.launchURL,
                                child: Icon(
                                  Icons.language,
                                  size: 30,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: widget.viewModel.launchURL,
                                  child: Text(
                                    'https://cs.kpnu.edu.ua/',
                                    style: TextStyle(
                                        fontSize: 14, color: AppColors.primary),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Електронна пошта: cs@kpnu.edu.ua, kaf_inf@kpnu.edu.ua',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        await widget.viewModel.signOut();
                        _onSignOutResults();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                        shadowColor: Colors.grey.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Вийти з акаунту',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSignOutResults() { // Реагує на вихід (viewModel.signOut()) і повертає на екран входу
    if (widget.viewModel.currentUser == null) {
      context.go(Routes.login);
    }
  }
}
