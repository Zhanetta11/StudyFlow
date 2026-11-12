import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      ('Mobile App Development', Icons.phone_android),
      ('Artificial Intelligence', Icons.psychology_outlined),
      ('Database Systems', Icons.storage_outlined),
      ('Computer Architecture', Icons.computer_outlined),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Courses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your subjects in one place',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ...courses.map(
            (course) => Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(course.$2, color: AppColors.primary),
                ),
                title: Text(
                  course.$1,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('View assignments'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
