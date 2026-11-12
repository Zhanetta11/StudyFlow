import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/assignments/data/repositories/assignment_repository.dart';
import 'features/assignments/presentation/bloc/assignment_bloc.dart';
import 'features/assignments/presentation/bloc/assignment_event.dart';
import 'shared/widgets/main_navigation.dart';

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AssignmentBloc(repository: AssignmentRepository())
            ..add(const LoadAssignments()),
      child: MaterialApp(
        title: 'StudyFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
