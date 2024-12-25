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
          // Фоновое изображение
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/profiley2.png'), // Шлях до зображення
                fit: BoxFit.cover, // Покриття всього фону
              ),
            ),
          ),
          // Логотип и текст, выровненные в левый верхний угол
          Positioned(
            top: 10, // Отступ от верха
            left: 20, // Отступ от левого края
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Выровнивание по левому краю
              children: [
                // Логотип
                Image.asset(
                  'assets/images/logo.png', // Путь к логотипу
                  height: 80, // Высота изображения
                  width: 80, // Ширина изображения
                ),
                const SizedBox(height: 8), // Отступ между логотипом и текстом
                // Текст под логотипом
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
          // Основной контент
          Center(
            child: Transform.translate(
              offset:
                  const Offset(0, 5), // Смещение контента вниз после логотипа
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                        height: 70), // Отступ между логотипом и аватаром
                    // Аватар вместо текста "Login"
                    Container(
                      width: 120, // Размер контейнера
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Форма контейнера
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 4), // Тень снизу
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60, // Размер аватара
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person, // Иконка профиля по умолчанию
                          size: 50,
                          color: AppColors.primary, // Цвет иконки
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 36), // Отступ между аватаром и кнопкой
                    // Кнопка "Войти"
                    ElevatedButton(
                      onPressed: () async {
                        await widget.viewModel.loginWithGoogle();
                        if (widget.viewModel.isLoggedIn) {
                          _onLoginResult();
                        }
                      }, // Вызов метода авторизации
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8, // Тень для кнопки
                        shadowColor:
                            Colors.grey.withOpacity(0.3), // Полупрозрачная тень
                      ),
                      child: const Text(
                        'Войти через Google',
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
