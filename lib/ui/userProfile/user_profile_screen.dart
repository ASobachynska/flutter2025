import 'package:digital_department_app/routing/routes.dart';
import 'package:digital_department_app/ui/userProfile/user_profile_viewmodel.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:digital_department_app/ui/core/ui/custom_link.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.viewModel});

  final UserProfileViewModel viewModel;

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
  void dispose() {
    widget.viewModel.removeListener(_onSignOutResults);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile3.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
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
                                  widget.viewModel.studentName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Група: ${widget.viewModel.group} | ${widget.viewModel.currentCourse} курс | ${widget.viewModel.degree}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Спеціальність: 122 Компʼютерні науки та інформаційні технології',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.viewModel.errorMessage ?? widget.viewModel.email,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Корисні посилання:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                ...widget.viewModel.usefulLinks
                                    .map((link) => CustomLink(
                                          text: link['title']!,
                                          url: link['url']!,
                                        ))
                                    .toList(),
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

  void _onSignOutResults() {
    if (widget.viewModel.currentUser == null) {
      context.go(Routes.login);
    }
  }
}
