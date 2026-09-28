import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subuhan/app/theme/app_theme.dart';
import 'package:subuhan/core/db/app_database.dart';
import 'package:subuhan/core/db/database_provider.dart';
import 'package:subuhan/core/l10n/app_localizations.dart';
import 'package:subuhan/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const alarmChannel = MethodChannel('club.threeam.subuhan/alarm');
  const eventsChannel = MethodChannel('club.threeam.subuhan/alarm_events');

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, (call) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventsChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventsChannel, null);
  });

  // FR-8.9: the dashboard empty state is welcoming, not a wall of zeros.
  testWidgets('dashboard empty state shows "Day 1 starts tonight"',
      (tester) async {
    final database = AppDatabase.connect(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Day 1 starts tonight.'), findsOneWidget);
    expect(
      find.text(
          'Sign your plan this evening — the first sunrise is tomorrow.'),
      findsOneWidget,
    );
    // No zeros wall: the streak/journey/week sections stay hidden.
    expect(find.text('Last 7 days'), findsNothing);

    await database.close();
  });
}
