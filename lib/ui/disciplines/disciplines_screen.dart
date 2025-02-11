import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:digital_department_app/ui/disciplines/disciplines_viewmodel.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisciplinesPage extends StatelessWidget {
  const DisciplinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => DisciplinesViewModel(authViewModel: authViewModel)..fetchDisciplines(),
      child: Scaffold(
        backgroundColor: AppColors.iconColor,
        appBar: AppBar(
          title: const Text(
            'Дисципліни',
            style: TextStyle(color: AppColors.iconColor),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Consumer<DisciplinesViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgrounds/profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Оберіть рік навчання: ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: viewModel.selectedYear,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.filterDisciplinesByYear(value);
                            }
                          },
                          items: List.generate(4, (index) {
                            int year = index + 1;
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text('$year'),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.hasError
                            ? Center(child: Text('Помилка: ${viewModel.errorMessage}'))
                            : viewModel.filteredDisciplines.isEmpty
                                ? const Center(child: Text('Дані відсутні'))
                                : ListView.builder(
                                    itemCount: viewModel.filteredDisciplines.length,
                                    itemBuilder: (context, index) {
                                      final row = viewModel.filteredDisciplines[index];
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
                                                    text:
                                                        '${row['discipline_name'] ?? 'Невідома дисципліна'} ',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '(${row['discipline_type'] ?? 'Тип не вказано'})\n',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        'Семестр: ${row['semester'] ?? 'Невідомо'}\n',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        'Форма контролю: ${row['exam_type'] ?? 'Невідомо'}\n',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Display grade only if it exists
                                                  if (row['grade'] != null && row['grade'] != '')
                                                    TextSpan(
                                                      text:
                                                          'Оцінка: ${row['grade']}\n',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  TextSpan(
                                                    text:
                                                        '${row['teacher_name'] ?? 'Викладач не вказаний'} ',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '(${row['teacher_email'] ?? 'Email не вказаний'})',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
