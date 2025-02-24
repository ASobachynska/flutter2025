import 'package:flutter/material.dart';
import 'package:digital_department_app/ui/core/ui/custom_link.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:digital_department_app/ui/grades/grades_viewmodel.dart';
import 'package:digital_department_app/ui/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class CurrentGradesPage extends StatelessWidget {
  const CurrentGradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) =>
          GradesViewModel(authViewModel: authViewModel)..fetchGrades(),
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
              image: AssetImage('assets/images/backgrounds/profile.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<GradesViewModel>(builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Оберіть семестр:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: viewModel.selectedSemester,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            onChanged: (value) {
                              if (value != null) {
                                viewModel.setSelectedSemester(value);
                              }
                            },
                            items: [
                              // Додаємо пункт для всіх семестрів
                              DropdownMenuItem<int>(
                                value: -1,
                                child: Text(
                                  'Всі',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                              ...viewModel.availableSemesters.map((semester) {
                                return DropdownMenuItem<int>(
                                  value: semester,
                                  child: Text(
                                    '$semester',
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.hasError
                          ? Center(
                              child: Text('Помилка: ${viewModel.errorMessage}'))
                          : viewModel.filteredGrades.isEmpty
                              ? const Center(child: Text('Дані відсутні'))
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: ListView.builder(
                                    itemCount: viewModel.filteredGrades.length,
                                    itemBuilder: (context, index) {
                                      final row = viewModel.filteredGrades[index];
                                      final teacherEmails =
                                          row['teacher_email'] ?? '';
                                      final emailList =
                                          teacherEmails.split(',');

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
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
                                                  if (row['grade'] != null && row['grade'] != '')
                                                    TextSpan(
                                                      text: 'Оцінка: ${row['grade']}\n',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  TextSpan(
                                                    text:
                                                        'Викладач: ${row['teacher_name'] ?? 'Викладач не вказаний'} ',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  for (var email in emailList)
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 4.0),
                                                        child: CustomLink(
                                                          text: email.trim(),
                                                          url:
                                                              'https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=Тема&body=Текст%20листа',
                                                        ),
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
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
