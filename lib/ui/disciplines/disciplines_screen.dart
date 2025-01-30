// Цей файл визначає DisciplinesPage, яка показує список дисциплін та 
// дозволяє обрати рік навчання через DropdownButton
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DisciplinesPage extends StatelessWidget {
  // final GSheets gsheets;
  // final String spreadsheetId;
  // final String studentEmail;

  const DisciplinesPage({super.key
      // Key? key,
      // required this.gsheets,
      // required this.spreadsheetId,
      // required this.studentEmail, // Received studentEmail
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Дисципліни',
          style: TextStyle(
            color: AppColors
                .iconColor, // Колір тексту "Поточні оцінки" змінений на AppColors.primary
          ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align the dropdown to the right
                children: [
                  // Label "Оберіть рік навчання"
                  const Text(
                    'Оберіть рік навчання: ',
                    style: TextStyle(
                      color: Colors.white, // White color for the label
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between label and dropdown
                  // Dropdown Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(1), // Light background for dropdown
                      borderRadius: BorderRadius.circular(
                          10), // Rounded corners for dropdown
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Blurred shadow
                          blurRadius: 10, // Blur effect
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: DropdownButton<int>(
                        hint: const Text('4'),
                        onChanged: (value) {
                          // Handle selection change
                        },
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('1'),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text('2'),
                          ),
                          DropdownMenuItem<int>(
                            value: 3,
                            child: Text('3'),
                          ),
                          DropdownMenuItem<int>(
                            value: 4,
                            child: Text(
                              '4',
                              style: TextStyle(
                                  color: Colors.grey), // Make the text grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } // Відображає список дисциплін, якщо snapshot.data містить значення
                  if (snapshot.hasError) {
                    return Center(child: Text('Помилка: ${snapshot.error}'));
                  }
                  final data = snapshot.data ?? [];
                  if (data.isEmpty) {
                    return const Center(child: Text('Дисципліни відсутні'));
                  }
// кожен елемент містить: 1 Назву дисципліни 2 Тип дисципліни 3 Семестр 4 Форма контролю 5 Викладача та його email
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final row = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                1), // Light background for readability
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
//умовно TODO: TapGestureRecognizer() для email поки що не відкриває поштовий клієнт – потрібно реалізувати launchUrl(emailUri)
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
            ),
          ],
        ),
      ),
    );
  }
}
