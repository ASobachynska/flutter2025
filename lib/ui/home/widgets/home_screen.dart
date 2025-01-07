import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_department_app/data/services/firestore/firestore.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Головна',
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
                      'assets/images/backgrounds/profile.png'), // Зображення на фоні
                  fit: BoxFit
                      .cover, // Масштабування зображення для покриття всього фону
                ),
              ),
            ),
          ),
          // Центральний контейнер з білим фоном та тінню, що обтікає зображення
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 16.0), // Відступи зверху та знизу
              child: Container(
                padding:
                    const EdgeInsets.all(10.0), // Відступи всередині контейнера
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
                child: Image.asset(
                  'assets/images/openlection.jpg', // Зображення всередині контейнера
                  fit: BoxFit.fitHeight, // Підлаштовує зображення під висоту
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: firestoreService.getMarks(),
              builder: (context, snaphot) {
                if (snaphot.hasData) {
                  List notesList = snaphot.data!.docs;
                  return ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = notesList[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String subjectName = data['name'];

                        return ListTile(
                          title: Text(
                              "Cпроба отримання данних від Firebase Storage. Знайдено предмет: $subjectName"),
                        );
                      });
                } else {
                  return const Text('No any data');
                }
              })
        ],
      ),
    );
  }
}
