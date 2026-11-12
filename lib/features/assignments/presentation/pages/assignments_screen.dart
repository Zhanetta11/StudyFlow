import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../bloc/assignment_bloc.dart';
import '../bloc/assignment_event.dart';
import '../bloc/assignment_state.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final bloc = context.read<AssignmentBloc>();

    String title = '';
    String course = '';

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('New Assignment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Assignment title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    course = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Course name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (title.trim().isEmpty || course.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                bloc.add(
                  AddAssignment(title: title.trim(), course: course.trim()),
                );

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Assignments')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: BlocBuilder<AssignmentBloc, AssignmentState>(
        builder: (context, state) {
          if (state is AssignmentLoading || state is AssignmentInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentError) {
            return Center(child: Text(state.message));
          }

          if (state is AssignmentLoaded) {
            final assignments = state.assignments;

            if (assignments.isEmpty) {
              return const Center(
                child: Text(
                  'No assignments yet.\nAdd your first task!',
                  textAlign: TextAlign.center,
                ),
              );
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
                    subtitle: Text(assignment.course),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      onPressed: () {
                        context.read<AssignmentBloc>().add(
                          DeleteAssignment(assignment.id),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
