import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Schedule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Plan your studies and deadlines',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  onDateChanged: (date) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
