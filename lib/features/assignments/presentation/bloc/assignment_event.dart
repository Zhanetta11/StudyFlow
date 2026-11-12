import 'package:equatable/equatable.dart';

abstract class AssignmentEvent extends Equatable {
  const AssignmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAssignments extends AssignmentEvent {
  const LoadAssignments();
}

class AddAssignment extends AssignmentEvent {
  final String title;
  final String course;
  final DateTime? dueDate;

  const AddAssignment({
    required this.title,
    required this.course,
    this.dueDate,
  });

  @override
  List<Object?> get props => [title, course, dueDate];
}

class ToggleAssignment extends AssignmentEvent {
  final String id;

  const ToggleAssignment(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAssignment extends AssignmentEvent {
  final String id;

  const DeleteAssignment(this.id);

  @override
  List<Object?> get props => [id];
}

class EditAssignment extends AssignmentEvent {
  final String id;
  final String title;
  final String course;
  final DateTime? dueDate;

  const EditAssignment({
    required this.id,
    required this.title,
    required this.course,
    this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, course, dueDate];
}
