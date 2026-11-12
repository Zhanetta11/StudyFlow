import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../bloc/assignment_bloc.dart';
import '../bloc/assignment_event.dart';
import '../bloc/assignment_state.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  // Format a date for display
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  // Check whether an assignment is overdue
  bool _isOverdue(DateTime? dueDate, bool isCompleted) {
    if (dueDate == null || isCompleted) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadline = DateTime(dueDate.year, dueDate.month, dueDate.day);

    return deadline.isBefore(today);
  }

  void _showAddDialog(BuildContext context) {
    final bloc = context.read<AssignmentBloc>();

    String title = '';
    String course = '';
    DateTime? selectedDate;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('New Assignment'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Assignment title',
                        prefixIcon: Icon(Icons.assignment_outlined),
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
                        prefixIcon: Icon(Icons.school_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Due Date (Optional)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () async {
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);

                        final pickedDate = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate ?? today,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          helpText: 'SELECT DEADLINE',
                        );

                        if (pickedDate != null && dialogContext.mounted) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        selectedDate == null
                            ? 'Choose deadline'
                            : _formatDate(selectedDate!),
                      ),
                    ),

                    if (selectedDate != null)
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            selectedDate = null;
                          });
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Remove date'),
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
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                      return;
                    }

                    bloc.add(
                      AddAssignment(
                        title: title.trim(),
                        course: course.trim(),
                        dueDate: selectedDate,
                      ),
                    );

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
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

                final overdue = _isOverdue(
                  assignment.dueDate,
                  assignment.isCompleted,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    isThreeLine: assignment.dueDate != null,

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

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(assignment.course),

                        if (assignment.dueDate != null) ...[
                          const SizedBox(height: 6),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: overdue
                                    ? AppColors.error
                                    : AppColors.primary,
                              ),

                              const SizedBox(width: 6),

                              Flexible(
                                child: Text(
                                  overdue
                                      ? 'Overdue: ${_formatDate(assignment.dueDate!)}'
                                      : 'Due: ${_formatDate(assignment.dueDate!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: overdue ? AppColors.error : null,
                                    fontWeight: overdue
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

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
