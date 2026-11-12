import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('Flutter Mid-term Project', 'Mobile App Development', false),
      ('Neural Network Lab', 'Artificial Intelligence', true),
      ('Database Assignment', 'Database Systems', false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Assignments')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Tasks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stay on top of your deadlines',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ...tasks.map(
            (task) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(
                  task.$3 ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.$3 ? AppColors.success : AppColors.primary,
                ),
                title: Text(
                  task.$1,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(task.$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
