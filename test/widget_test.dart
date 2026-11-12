import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:studyflow/features/assignments/data/models/assignment.dart';
import 'package:studyflow/features/assignments/data/repositories/assignment_repository.dart';
import 'package:studyflow/features/assignments/presentation/bloc/assignment_bloc.dart';
import 'package:studyflow/features/assignments/presentation/bloc/assignment_event.dart';
import 'package:studyflow/features/assignments/presentation/bloc/assignment_state.dart';
import 'package:studyflow/features/home/presentation/pages/home_screen.dart';

class FakeAssignmentRepository extends AssignmentRepository {
  @override
  Future<List<Assignment>> getAssignments() async {
    return [
      Assignment(
        id: '1',
        title: 'Flutter Mid-term Project',
        course: 'Mobile App Development',
        isCompleted: false,
      ),
      Assignment(
        id: '2',
        title: 'Neural Network Lab',
        course: 'Artificial Intelligence',
        isCompleted: true,
      ),
    ];
  }
}

void main() {
  testWidgets('Home dashboard displays study information', (
    WidgetTester tester,
  ) async {
    final bloc = AssignmentBloc(repository: FakeAssignmentRepository());

    addTearDown(bloc.close);

    // Load assignments before building the dashboard.
    bloc.add(const LoadAssignments());

    // Wait until the BLoC has loaded the fake data.
    await bloc.stream.firstWhere((state) => state is AssignmentLoaded);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();

    // Check the dashboard greeting.
    expect(find.text('Hello, Student! 👋'), findsOneWidget);

    // Check the overview labels.
    expect(find.text('Total Tasks'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    // Check that the dashboard uses real statistics.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Check the pending assignment in the widget tree.
    expect(
      find.text('Flutter Mid-term Project', skipOffstage: false),
      findsOneWidget,
    );
  });
}
