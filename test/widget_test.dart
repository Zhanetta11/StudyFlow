import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyflow/app.dart';

void main() {
  testWidgets('StudyFlow welcome screen test', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const StudyFlowApp());

    expect(
      find.text('Welcome to StudyFlow!'),
      findsOneWidget,
    );

    expect(
      find.byType(MaterialApp),
      findsOneWidget,
    );
  });
}