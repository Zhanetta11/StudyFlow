import 'package:equatable/equatable.dart';

import '../../data/models/assignment.dart';

abstract class AssignmentState extends Equatable {
  const AssignmentState();

  @override
  List<Object?> get props => [];
}

class AssignmentInitial extends AssignmentState {
  const AssignmentInitial();
}

class AssignmentLoading extends AssignmentState {
  const AssignmentLoading();
}

class AssignmentLoaded extends AssignmentState {
  final List<Assignment> assignments;

  const AssignmentLoaded(this.assignments);

  @override
  List<Object?> get props => [assignments];
}

class AssignmentError extends AssignmentState {
  final String message;

  const AssignmentError(this.message);

  @override
  List<Object?> get props => [message];
}
