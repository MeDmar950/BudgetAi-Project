import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_ai/main.dart';

void main() {
  testWidgets(
    'Bottom navigation switches tabs and shows corresponding screens',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BudgetAiApp());
      await tester.pumpAndSettle();

      // Default tab is Accounts (Arabic: الحسابات)
      expect(find.text('إجمالي الرصيد'), findsOneWidget);

      // Switch to Transactions tab (المعاملات)
      await tester.tap(find.byIcon(Icons.receipt_long_outlined));
      await tester.pumpAndSettle();
      expect(find.text('لا توجد معاملات بعد'), findsOneWidget);

      // Switch to Budgets tab (الميزانيات)
      await tester.tap(find.byIcon(Icons.pie_chart_outline_rounded));
      await tester.pumpAndSettle();
      expect(find.text('الميزانيات'), findsWidgets);

      // Switch to Analytics tab (التحليلات)
      await tester.tap(find.byIcon(Icons.bar_chart_outlined));
      await tester.pumpAndSettle();
      expect(find.text('التحليلات'), findsWidgets);

      // Switch to Settings tab (الإعدادات)
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.text('الإعدادات'), findsWidgets);
      expect(find.text('العربية (مصر)'), findsOneWidget);
    },
  );
}
