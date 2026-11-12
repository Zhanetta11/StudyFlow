import 'package:flutter_test/flutter_test.dart';
import 'package:studyflow/app.dart';

void main() {
  testWidgets('Home dashboard displays study information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const StudyFlowApp());

    expect(find.text('StudyFlow'), findsOneWidget);
    expect(find.text('Hello, Student! 👋'), findsOneWidget);
    expect(find.text('Your Study Progress'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
  });
}