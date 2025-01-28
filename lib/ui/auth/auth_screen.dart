import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  final AuthViewModel viewModel;
  const AuthScreen({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onLoginResult);
  }

  @override
  void didUpdateWidget(covariant AuthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.removeListener(_onLoginResult);
    oldWidget.viewModel.addListener(_onLoginResult);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onLoginResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profiley2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Кам`янець-Подільський \nнаціональний університет \nімені Івана Огієнка',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, 5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 70),
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
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    ElevatedButton(
                      onPressed: () async {
                        await widget.viewModel.loginWithGoogle();
                        if (widget.viewModel.isLoggedIn) {
                          _onLoginResult();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.grey.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Увійти через Google',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.viewModel.isLoggedIn &&
                        widget.viewModel.errorMessage != null)
                      Text(
                        widget.viewModel.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onLoginResult() {
    if (widget.viewModel.isLoggedIn) {
      context.goNamed('home');
    }
    if (widget.viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          content: Text(widget.viewModel.errorMessage ?? 'Unknown error'),
        ),
      );
    }
  }
}
