import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:digital_department_app/ui/grades/grades_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentGradesPage extends StatelessWidget {
  const CurrentGradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GradesViewModel()..fetchGrades(), // Завантаження оцінок при створенні
      child: Scaffold(
        backgroundColor: AppColors.iconColor,
        appBar: AppBar(
          title: const Text(
            'Підсумкові оцінки',
            style: TextStyle(color: AppColors.iconColor),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/profile.png'), // Шлях до зображення
              fit: BoxFit.cover, // Масштабування зображення
            ),
          ),
          child: Consumer<GradesViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (viewModel.hasError) {
                return Center(child: Text('Помилка: ${viewModel.errorMessage}'));
              }
              if (viewModel.grades.isEmpty) {
                return const Center(child: Text('Дані відсутні'));
              }
              return ListView.builder(
                itemCount: viewModel.grades.length,
                itemBuilder: (context, index) {
                  final row = viewModel.grades[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${row['discipline_name']} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '(${row['discipline_type']})\n',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: 'Семестр: ${row['semester']}\n',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Форма контролю: ${row['exam_type']}\n',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Оцінка: ${row['grade']}\n',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: '${row['teacher_name']} ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '(${row['teacher_email']})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: null, // Можна додати GestureRecognizer
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
