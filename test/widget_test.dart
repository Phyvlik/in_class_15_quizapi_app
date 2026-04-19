import 'package:flutter_test/flutter_test.dart';
import 'package:in_class_15_api/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(find.byType(QuizApp), findsOneWidget);
  });
}
