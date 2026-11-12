import '../../assignments/data/models/assignment.dart';

class StudyStatistics {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final double progress;

  const StudyStatistics({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.progress,
  });

  factory StudyStatistics.fromAssignments(List<Assignment> assignments) {
    final total = assignments.length;

    final completed = assignments
        .where((assignment) => assignment.isCompleted)
        .length;

    final pending = total - completed;

    final progress = total == 0 ? 0.0 : completed / total;

    return StudyStatistics(
      totalTasks: total,
      completedTasks: completed,
      pendingTasks: pending,
      progress: progress,
    );
  }

  int get progressPercentage => (progress * 100).round();
}
