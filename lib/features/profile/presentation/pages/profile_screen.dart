import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person, size: 48, color: AppColors.primary),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Student',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'student@studyflow.app',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About StudyFlow'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
