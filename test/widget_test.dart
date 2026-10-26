import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_ai/main.dart';

void main() {
  testWidgets('BudgetAiApp renders shell and can toggle locale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BudgetAiApp());
    await tester.pumpAndSettle();

    // Verify Arabic default strings are rendered
    expect(find.text('BudgetAI'), findsOneWidget);
    expect(find.text('إجمالي الرصيد'), findsOneWidget);
    expect(find.text('دخل'), findsOneWidget);
    expect(find.text('مصروف'), findsOneWidget);

    // Switch language to English
    final switchLangChip = find.byType(ActionChip);
    expect(switchLangChip, findsOneWidget);
    await tester.tap(switchLangChip);
    await tester.pumpAndSettle();

    // Verify English strings are rendered
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
  });
}
