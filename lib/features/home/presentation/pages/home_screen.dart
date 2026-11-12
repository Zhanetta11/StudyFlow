import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../assignments/presentation/bloc/assignment_bloc.dart';
import '../../../assignments/presentation/bloc/assignment_event.dart';
import '../../../assignments/presentation/bloc/assignment_state.dart';
import '../../models/study_statistics.dart';
import '../widgets/assignment_card.dart';
import '../widgets/progress_card.dart';
import '../../../assignments/data/models/assignment.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDeadline(DateTime? dueDate) {
    if (dueDate == null) {
      return 'No deadline';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadline = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = deadline.difference(today).inDays;

    if (difference < 0) {
      return 'Overdue';
    }

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');

    return '$day.$month.${deadline.year}';
  }

  bool _isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final deadline = DateTime(dueDate.year, dueDate.month, dueDate.day);

    return deadline.isBefore(today);
  }

  // Sort pending assignments by nearest deadline.
  List<Assignment> _getUpcomingAssignments(List<Assignment> assignments) {
    final pending = assignments
        .where((assignment) => !assignment.isCompleted)
        .toList();

    pending.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) {
        return 0;
      }

      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return pending.take(3).toList();
  }

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
            onPressed: () {
              context.read<AssignmentBloc>().add(const LoadAssignments());
            },
            tooltip: 'Refresh assignments',
            icon: const Icon(Icons.refresh_rounded),
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
      body: BlocBuilder<AssignmentBloc, AssignmentState>(
        builder: (context, state) {
          if (state is AssignmentLoading || state is AssignmentInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
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
            final statistics = StudyStatistics.fromAssignments(
              state.assignments,
            );

            final pendingAssignments = _getUpcomingAssignments(
              state.assignments,
            );

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<AssignmentBloc>();

                bloc.add(const LoadAssignments());

                await bloc.stream.firstWhere(
                  (state) =>
                      state is AssignmentLoaded || state is AssignmentError,
                );
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Hello, Student! 👋',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ready to make progress today?',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ProgressCard(
                    progress: statistics.progress,
                    completed: statistics.completedTasks,
                    total: statistics.totalTasks,
                  ),

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
                          statistics.totalTasks.toString(),
                          'Total Tasks',
                          Icons.assignment_outlined,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _overviewCard(
                          statistics.completedTasks.toString(),
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

                  if (pendingAssignments.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 42,
                            color: AppColors.success,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'All caught up!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'No pending assignments.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    ...pendingAssignments.map(
                      (assignment) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AssignmentCard(
                          title: assignment.title,
                          course: assignment.course,
                          deadline: _formatDeadline(assignment.dueDate),
                          isOverdue: _isOverdue(assignment.dueDate),
                          icon: Icons.menu_book_rounded,
                          iconColor: AppColors.primary,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
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
