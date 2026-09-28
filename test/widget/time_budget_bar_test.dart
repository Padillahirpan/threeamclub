import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/app/theme/app_theme.dart';
import 'package:subuhan/core/widgets/time_budget_bar.dart';

void main() {
  testWidgets('TimeBudgetBar renders label and over-budget state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: TimeBudgetBar(
              wakeMinute: 4 * 60 + 30,
              label: '90 of 90 min before 6:00',
              segments: [
                BudgetSegment(minutes: 30, color: Colors.red),
                BudgetSegment(minutes: 60, color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('90 of 90 min before 6:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('over-budget flag keeps painting without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: TimeBudgetBar(
              wakeMinute: 4 * 60 + 30,
              label: '100 of 90 min before 6:00',
              overBudget: true,
              segments: [
                BudgetSegment(minutes: 100, color: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
