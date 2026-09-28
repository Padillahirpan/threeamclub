import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/app/theme/app_theme.dart';
import 'package:subuhan/core/widgets/hold_button.dart';

Future<int> pumpAndHold(WidgetTester tester, Duration hold) async {
  var completed = 0;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(
        body: Center(
          child: HoldButton(
            duration: const Duration(seconds: 3),
            label: 'Hold',
            onCompleted: () => completed++,
          ),
        ),
      ),
    ),
  );

  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(HoldButton)),
  );
  await tester.pump();
  await tester.pump(hold);
  await gesture.up();
  await tester.pumpAndSettle();
  return completed;
}

void main() {
  testWidgets('a 2.9s hold does not sign (PRD FR-3.3 acceptance)', (
    tester,
  ) async {
    final completed = await pumpAndHold(
      tester,
      const Duration(milliseconds: 2900),
    );
    expect(completed, 0);
  });

  testWidgets('a 3s hold completes', (tester) async {
    final completed = await pumpAndHold(tester, const Duration(seconds: 3));
    expect(completed, 1);
  });
}
