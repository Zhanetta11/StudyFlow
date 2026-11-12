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

  const AddAssignment({required this.title, required this.course});

  @override
  List<Object?> get props => [title, course];
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
