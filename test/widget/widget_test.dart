import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subuhan/app/app.dart';
import 'package:subuhan/core/db/app_database.dart';
import 'package:subuhan/features/onboarding/data/onboarding_repository.dart';
import 'package:subuhan/features/promises/data/drift_category_repository.dart';
import 'package:subuhan/features/promises/domain/category.dart';

class _FakeCategoryRepository implements CategoryRepository {
  @override
  Stream<List<Category>> watchAll() => Stream.value(const [
        Category(
          id: 'cat-spiritual',
          name: 'Spiritual',
          iconKey: 'spiritual',
          colorKey: 'dawn',
          isBuiltIn: true,
          isArchived: false,
        ),
        Category(
          id: 'cat-body',
          name: 'Body',
          iconKey: 'body',
          colorKey: 'green',
          isBuiltIn: true,
          isArchived: false,
        ),
      ]);

  @override
  Future<Category> createCustom({
    required String name,
    required String iconKey,
    required String colorKey,
  }) async => throw UnimplementedError();

  @override
  Future<void> updateCustom({
    required String id,
    required String name,
    required String iconKey,
    required String colorKey,
  }) async => throw UnimplementedError();

  @override
  Future<void> archive(String id) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const alarmChannel = MethodChannel('club.threeam.subuhan/alarm');
  const eventsChannel = MethodChannel('club.threeam.subuhan/alarm_events');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, (call) async {
      switch (call.method) {
        case 'checkPermissions':
          return <String, Object>{
            'notifications': true,
            'fullScreenIntent': true,
            'batteryOptimizationIgnored': false,
            'sdkInt': 34,
            'manufacturer': 'test',
          };
        default:
          return null;
      }
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventsChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventsChannel, null);
  });

  testWidgets('app opens on the sleep plan after onboarding', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_done': true,
    });
    final prefs = await SharedPreferences.getInstance();

    // In-memory DB: the router's DayPhase redirect reads the plan state.
    final database = AppDatabase.connect(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryRepositoryProvider
              .overrideWithValue(_FakeCategoryRepository()),
          onboardingRepositoryProvider
              .overrideWithValue(OnboardingRepository(prefs)),
          databaseProvider.overrideWithValue(database),
        ],
        child: const SubuhanApp(),
      ),
    );
    await tester.pumpAndSettle();

    // No plan → noPlan phase → /plan (EN default locale in tests).
    expect(find.text('Sleep plan'), findsOneWidget);
    expect(find.text('Bedtime'), findsOneWidget);
    expect(find.text('Wake time'), findsOneWidget);
    expect(find.text('7h of sleep'), findsOneWidget); // 21:00 → 04:00

    await database.close();
  });

  // Regression: fresh install must land on /onboarding without a
  // "/onboarding => /plan => /onboarding" redirect loop.
  testWidgets('fresh install lands on onboarding without a redirect loop',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    final database = AppDatabase.connect(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryRepositoryProvider
              .overrideWithValue(_FakeCategoryRepository()),
          onboardingRepositoryProvider
              .overrideWithValue(OnboardingRepository(prefs)),
          databaseProvider.overrideWithValue(database),
        ],
        child: const SubuhanApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to the 3AM Club'), findsOneWidget);

    await database.close();
  });
}
