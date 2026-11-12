import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/assignment.dart';
import '../../data/repositories/assignment_repository.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentRepository repository;

  AssignmentBloc({required this.repository})
    : super(const AssignmentInitial()) {
    on<LoadAssignments>(_onLoad);
    on<AddAssignment>(_onAdd);
    on<ToggleAssignment>(_onToggle);
    on<DeleteAssignment>(_onDelete);
  }

  final List<Assignment> _assignments = [];

  // GET - Load assignments from backend
  Future<void> _onLoad(
    LoadAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(const AssignmentLoading());

    try {
      final assignments = await repository.getAssignments();

      _assignments
        ..clear()
        ..addAll(assignments);

      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    } catch (e) {
      emit(AssignmentError('Failed to load assignments: $e'));
    }
  }

  // POST - Create assignment in database
  Future<void> _onAdd(
    AddAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    final title = event.title.trim();
    final course = event.course.trim();

    if (title.isEmpty || course.isEmpty) {
      emit(const AssignmentError('Please fill in all fields'));
      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
      return;
    }

    try {
      final assignment = await repository.createAssignment(
        title: title,
        course: course,
      );

      _assignments.add(assignment);

      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    } catch (e) {
      emit(AssignmentError('Failed to add assignment: $e'));
      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    }
  }

  // PUT - Toggle assignment completion status
  Future<void> _onToggle(
    ToggleAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    final index = _assignments.indexWhere(
      (assignment) => assignment.id == event.id,
    );

    if (index == -1) return;

    final current = _assignments[index];

    try {
      final updated = await repository.updateAssignment(
        current.copyWith(isCompleted: !current.isCompleted),
      );

      _assignments[index] = updated;

      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    } catch (e) {
      emit(AssignmentError('Failed to update assignment: $e'));
      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    }
  }

  // DELETE - Remove assignment from database
  Future<void> _onDelete(
    DeleteAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    try {
      await repository.deleteAssignment(event.id);

      _assignments.removeWhere((assignment) => assignment.id == event.id);

      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    } catch (e) {
      emit(AssignmentError('Failed to delete assignment: $e'));
      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
    }
  }
}
