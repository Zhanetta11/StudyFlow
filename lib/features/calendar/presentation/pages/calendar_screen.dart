import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../assignments/data/models/assignment.dart';
import '../../../assignments/presentation/bloc/assignment_bloc.dart';
import '../../../assignments/presentation/bloc/assignment_event.dart';
import '../../../assignments/presentation/bloc/assignment_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Assignment> _assignmentsForDay(
    DateTime day,
    List<Assignment> assignments,
  ) {
    return assignments.where((assignment) {
      final dueDate = assignment.dueDate;

      if (dueDate == null) return false;

      return isSameDay(dueDate, day);
    }).toList();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Calendar'),
        actions: [
          IconButton(
            tooltip: 'Refresh assignments',
            icon: const Icon(Icons.refresh),
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
                child: Text(state.message),
              ),
            );
          }

          if (state is AssignmentLoaded) {
            final assignments = state.assignments;

            final selectedAssignments = _assignmentsForDay(
              _selectedDay,
              assignments,
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Plan your studies',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 6),

                Text(
                  'Stay organized and never miss a deadline.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),

                const SizedBox(height: 20),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TableCalendar<Assignment>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),

                      focusedDay: _focusedDay,

                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },

                      eventLoader: (day) {
                        return _assignmentsForDay(day, assignments);
                      },

                      calendarFormat: CalendarFormat.month,

                      startingDayOfWeek: StartingDayOfWeek.monday,

                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },

                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },

                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },

                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                        ),

                        todayTextStyle: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),

                        selectedDecoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),

                        markerDecoration: BoxDecoration(
                          color: colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),

                        markersMaxCount: 3,
                      ),

                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(_selectedDay),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    Text(
                      '${selectedAssignments.length} tasks',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (selectedAssignments.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            size: 40,
                            color: colorScheme.primary,
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'No assignments for this day',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...selectedAssignments.map((assignment) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          assignment.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: assignment.isCompleted
                              ? Colors.green
                              : colorScheme.primary,
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
                          tooltip: 'Toggle completion',
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            context.read<AssignmentBloc>().add(
                              ToggleAssignment(assignment.id),
                            );
                          },
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
