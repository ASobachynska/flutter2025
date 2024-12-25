import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CurrentGradesPage extends StatelessWidget {
  // final String spreadsheetId;
  // final String studentEmail; // Added email parameter

//TODO: Rebuild this widget corresponding MVVM
  const CurrentGradesPage({
    super.key,
    //required this.gsheets,
    // required this.spreadsheetId,
    // required this.studentEmail, // Received email
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iconColor,
      appBar: AppBar(
        title: const Text(
          'Підсумкові оцінки',
          style: TextStyle(
            color: AppColors
                .iconColor, // Колір тексту "Поточні оцінки" змінений на AppColors.primary
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          // Фонове зображення
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profile.png'), // Ваше зображення
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Заголовок
          // Positioned(
          //   top: 40, // Відступ від верху
          //   left: 16, // Відступ від лівого краю
          //   child: Text(
          //     'Поточні оцінки', // Текст заголовка
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white, // Колір тексту
          //     ),
          //   ),
          // ),
          // Основний контент
          FutureBuilder<List<Map<String, String>>>(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Помилка: ${snapshot.error}'));
              }
              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('Дані відсутні'));
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final row = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(1), // Light background for readability
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10)
                        ], // Shadow
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${row['discipline_name']} ', // Назва дисципліни
                                style: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Make the discipline name bold
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '(${row['discipline_type']})\n', // Тип дисципліни
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
                                text:
                                    'Форма підсумкового контролю: ${row['exam_type']}\n',
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
                                children: [
                                  TextSpan(
                                    text: '(${row['teacher_email']})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration
                                          .underline, // Підкреслення
                                      decorationColor: Colors
                                          .grey, // Сірий колір підкреслення
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        final Uri emailUri = Uri(
                                          scheme: 'mailto',
                                          path: row['teacher_email'],
                                          query: Uri.encodeQueryComponent(
                                            'subject=Запитання щодо дисципліни',
                                          ),
                                        );
                                        // Виклик поштового клієнта
                                      },
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
