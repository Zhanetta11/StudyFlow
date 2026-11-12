import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/assignment.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(const AssignmentInitial()) {
    on<LoadAssignments>(_onLoad);
    on<AddAssignment>(_onAdd);
    on<ToggleAssignment>(_onToggle);
    on<DeleteAssignment>(_onDelete);
  }

  final List<Assignment> _assignments = [];

  int _nextId = 1;

  void _onLoad(LoadAssignments event, Emitter<AssignmentState> emit) {
    emit(const AssignmentLoading());

    emit(AssignmentLoaded(List.unmodifiable(_assignments)));
  }

  void _onAdd(AddAssignment event, Emitter<AssignmentState> emit) {
    final title = event.title.trim();
    final course = event.course.trim();

    if (title.isEmpty || course.isEmpty) {
      emit(const AssignmentError('Please fill in all fields'));
      emit(AssignmentLoaded(List.unmodifiable(_assignments)));
      return;
    }

    _assignments.add(
      Assignment(id: (_nextId++).toString(), title: title, course: course),
    );

    emit(AssignmentLoaded(List.unmodifiable(_assignments)));
  }

  void _onToggle(ToggleAssignment event, Emitter<AssignmentState> emit) {
    final index = _assignments.indexWhere(
      (assignment) => assignment.id == event.id,
    );

    if (index == -1) return;

    final current = _assignments[index];

    _assignments[index] = current.copyWith(isCompleted: !current.isCompleted);

    emit(AssignmentLoaded(List.unmodifiable(_assignments)));
  }

  void _onDelete(DeleteAssignment event, Emitter<AssignmentState> emit) {
    _assignments.removeWhere((assignment) => assignment.id == event.id);

    emit(AssignmentLoaded(List.unmodifiable(_assignments)));
  }
}
