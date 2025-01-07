import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  //TODO: add viewmodel into constructor and other mandatory fields
  const SchedulePage({super.key});

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // You can use the selected date as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Розклад',
          style: TextStyle(
            color: AppColors.iconColor,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          // Фонове зображення
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/backgrounds/profile.png'), // Зображення на фоні
                  fit: BoxFit.cover, // Масштабування для покриття всього екрану
                ),
              ),
            ),
          ),
          // Контейнер для вибору дати
          Positioned(
            top: 20.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Розміщує елементи праворуч
              children: [
                // Текст з підкресленням зліва від кнопки
                const Text(
                  '14.10-18.10.2024',
                  style: TextStyle(
                    color: Colors.white, // Білий текст
                    fontSize: 16,
                    decoration:
                        TextDecoration.underline, // Додаємо підкреслення
                    decorationColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10), // Відстань між текстом і кнопкою
                // Кнопка для вибору дати
                TextButton(
                  onPressed: () {
                    _selectDate(context); // Показати діалог вибору дати
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: Colors.white, // Білий фон
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Вибрати',
                    style: TextStyle(
                      color: Colors.black, // Чорний текст
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Контейнер для зображення розкладу
          Positioned(
            top: 70.0, // Відстань від верхнього блоку
            left: 80.0,
            right: 80.0,
            bottom: 16.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white, // Білий фон
                borderRadius: BorderRadius.circular(12), // Округлені кути
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/scheduleshort.jpg', // Зображення розкладу
                  fit: BoxFit.contain, // Підлаштовує зображення під розмір
                  width: double.infinity, // Повна ширина контейнера
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
