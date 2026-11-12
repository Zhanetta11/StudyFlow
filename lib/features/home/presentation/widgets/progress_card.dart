import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFAD8CF4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Your Study Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0).toDouble(),
            minHeight: 9,
            backgroundColor: Colors.white30,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 14),
          Text(
            '$completed of $total assignments completed',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
