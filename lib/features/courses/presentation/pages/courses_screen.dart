import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../assignments/data/models/assignment.dart';
import '../../../assignments/presentation/bloc/assignment_bloc.dart';
import '../../../assignments/presentation/bloc/assignment_event.dart';
import '../../../assignments/presentation/bloc/assignment_state.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: 'Refresh courses',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<AssignmentBloc>().add(const LoadAssignments());
            },
          ),
        ],
      ),
      body: BlocBuilder<AssignmentBloc, AssignmentState>(
        builder: (context, state) {
          if (state is AssignmentInitial || state is AssignmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<AssignmentBloc>().add(
                          const LoadAssignments(),
                        );
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AssignmentLoaded) {
            final courses = <String, List<Assignment>>{};

            for (final assignment in state.assignments) {
              final courseName = assignment.course.trim();

              if (courseName.isEmpty) continue;

              courses
                  .putIfAbsent(courseName, () => <Assignment>[])
                  .add(assignment);
            }

            final courseNames = courses.keys.toList()..sort();

            if (courseNames.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No courses yet.\n'
                    'Add an assignment to create your first course!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  '${courseNames.length} Courses',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Track your progress in each subject',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                ...courseNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final name = entry.value;
                  final assignments = courses[name]!;

                  final completed = assignments
                      .where((a) => a.isCompleted)
                      .length;

                  final total = assignments.length;
                  final progress = completed / total;

                  final colors = [
                    AppColors.primary,
                    Colors.teal,
                    Colors.orange,
                    Colors.blue,
                    Colors.pink,
                  ];

                  final color = colors[index % colors.length];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                CourseDetailsScreen(courseName: name),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$completed of $total assignments completed',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                color: color,
                                backgroundColor: color.withValues(alpha: 0.12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CourseDetailsScreen extends StatelessWidget {
  final String courseName;

  const CourseDetailsScreen({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: BlocBuilder<AssignmentBloc, AssignmentState>(
        builder: (context, state) {
          if (state is AssignmentInitial || state is AssignmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentError) {
            return Center(child: Text(state.message));
          }

          if (state is! AssignmentLoaded) {
            return const SizedBox.shrink();
          }

          final assignments = state.assignments
              .where((assignment) => assignment.course.trim() == courseName)
              .toList();

          if (assignments.isEmpty) {
            return const Center(child: Text('No assignments in this course.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: IconButton(
                    tooltip: 'Toggle completion',
                    icon: Icon(
                      assignment.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: assignment.isCompleted
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                    onPressed: () {
                      context.read<AssignmentBloc>().add(
                        ToggleAssignment(assignment.id),
                      );
                    },
                  ),
                  title: Text(
                    assignment.title,
                    style: TextStyle(
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    assignment.dueDate == null
                        ? 'No deadline'
                        : 'Due: ${_formatDate(assignment.dueDate!)}',
                  ),
                  trailing: Icon(
                    assignment.isCompleted
                        ? Icons.task_alt
                        : Icons.pending_outlined,
                    color: assignment.isCompleted
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day.$month.${date.year}';
  }
}