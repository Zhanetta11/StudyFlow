import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/assignment_card.dart';
import '../widgets/progress_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'StudyFlow',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person_outline, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Hello, Student! 👋',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ready to make progress today?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),

          const ProgressCard(progress: 0.75, completed: 9, total: 12),

          const SizedBox(height: 28),
          const Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _overviewCard(
                  '12',
                  'Total Tasks',
                  Icons.assignment_outlined,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _overviewCard(
                  '9',
                  'Completed',
                  Icons.check_circle_outline,
                  AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          const Text(
            'Upcoming Assignments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          const AssignmentCard(
            title: 'Flutter Mid-term Project',
            course: 'Mobile App Development',
            deadline: 'Nov 15',
            icon: Icons.phone_android,
            iconColor: AppColors.primary,
          ),
          const AssignmentCard(
            title: 'Neural Network Lab',
            course: 'Artificial Intelligence',
            deadline: 'Nov 18',
            icon: Icons.psychology_outlined,
            iconColor: AppColors.warning,
          ),
          const AssignmentCard(
            title: 'Database Assignment',
            course: 'Database Systems',
            deadline: 'Nov 20',
            icon: Icons.storage_outlined,
            iconColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
