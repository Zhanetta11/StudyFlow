import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_screen.dart';

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
