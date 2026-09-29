import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subuhan/app/app.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart';
import 'package:subuhan/core/db/database_provider.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/core/widgets/hold_button.dart';
import 'package:subuhan/features/onboarding/data/onboarding_repository.dart';
import 'package:subuhan/features/plan/application/phase_providers.dart';
import 'package:subuhan/features/plan/application/plan_draft_controller.dart';
import 'package:subuhan/features/plan/data/morning_repository.dart';
import 'package:subuhan/features/plan/data/plan_repository.dart';
import 'package:subuhan/features/plan/domain/plan_draft.dart';

class _FakeNotificationService extends NotificationService {
  @override
  Future<void> init({void Function(String payload)? onRoute}) async {}

  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelBedtimeReminder() async {}

  @override
  Future<void> scheduleTimerComplete({
    required DateTime at,
    required String title,
    required String body,
    required String payload,
  }) async {}

  @override
  Future<void> cancelTimerComplete() async {}
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
            'batteryOptimizationIgnored': true,
            'sdkInt': 34,
            'manufacturer': 'test',
          };
        default:
          return null; // schedule / cancel / stopRinging
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

  /// The full user journey (ARCHITECTURE.md §16 integration path):
  /// plan → sign → (night) → simulated alarm → hold → focus → timer →
  /// dashboard.
  testWidgets('plan → sign → alarm → hold → focus → timer → dashboard',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'onboarding_done': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.connect(NativeDatabase.memory());
    final clock = MutableClock(DateTime(2026, 9, 28, 20, 0)); // Mon 8pm

    final container = ProviderContainer(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(OnboardingRepository(prefs)),
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(clock),
        notificationServiceProvider
            .overrideWithValue(_FakeNotificationService()),
      ],
    );
    // Teardown happens explicitly at the end of the body (see below).

    // Seed one small promise into the draft (the sheet itself is covered
    // by the M1 widget tests; here the journey is the point).
    container.read(planDraftProvider.notifier).addPromise(
          const PromiseDraft(
            id: 'p1',
            categoryId: 'cat-spiritual',
            title: "Du'a on waking",
            durationMin: 5,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SubuhanApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // ---- 1. Plan → promises ------------------------------------------------
    expect(find.text('Sleep plan'), findsOneWidget);
    await tester.tap(find.text('Next: choose your morning promises'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Morning promises'), findsOneWidget);

    // ---- 2. Promises → sign ------------------------------------------------
    await tester.ensureVisible(find.byType(FilledButton).first);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(FilledButton).first, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Hold to sign'), findsOneWidget);

    // ---- 3. Hold 3s to sign (FR-3.3) ---------------------------------------
    final signGesture = await tester.startGesture(
      tester.getCenter(find.byType(HoldButton)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await signGesture.up();
    // Flush the async signPlan + navigation (no pumpAndSettle: the night
    // waves animate forever by design).
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Tonight, you keep your promise.'), findsOneWidget);

    // ---- 4. The alarm fires (Tue 04:02) ------------------------------------
    clock.set(DateTime(2026, 9, 29, 4, 2));
    container.read(phaseTickProvider.notifier).bump(); // app-resume tick
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Good morning. You said you would.'), findsOneWidget);

    // ---- 5. Hold 5s to stop the alarm + confirm the wake (FR-5.3) ----------
    final wakeGesture = await tester.startGesture(
      tester.getCenter(find.byType(HoldButton)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await wakeGesture.up();
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Focus: one promise, not started.
    expect(find.text("Du'a on waking"), findsOneWidget);

    // Wake recorded.
    final morningAfterWake =
        await container.read(morningRepositoryProvider).relevantMorning();
    expect(morningAfterWake!.wakeConfirmedAt, isNotNull);

    // ---- 6. Open the promise timer and start it (FR-7.x) -------------------
    await tester.tap(find.text("Du'a on waking"));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.text('Start'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Running: Complete disabled with minutes-left caption.
    expect(find.text('5 min left'), findsOneWidget);

    // ---- 7. Countdown elapses → Complete (gold) ----------------------------
    clock.set(DateTime(2026, 9, 29, 4, 8)); // 5-minute promise done
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Complete'));
    // Celebration (~900ms); all promises kept → phase done → the router
    // lands on the dashboard by itself.
    for (var i = 0; i < 14; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // The promise log is kept.
    final keptMorning =
        await container.read(morningRepositoryProvider).relevantMorning();
    expect(keptMorning!.keptPromises, 1);
    expect(keptMorning.totalPromises, 1);

    // ---- 8. 06:00 closes the morning → dashboard ---------------------------
    final toClose =
        await container.read(morningRepositoryProvider).relevantMorning();
    await container.read(morningRepositoryProvider).closeMorning(toClose!.id);

    clock.set(DateTime(2026, 9, 29, 6, 30));
    container.read(phaseTickProvider.notifier).bump();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Your progress'), findsOneWidget);
    // All promises kept → full morning hero (1 of 1).
    expect(find.text('Every promise kept. Look at that sun.'), findsOneWidget);

    // Explicit teardown inside the body: the container is external (not
    // tree-owned), so disposing it here cancels the PhaseTick periodic
    // timer; drift's stream-store cleanup schedules zero-duration timers
    // that the final pump flushes. The in-memory DB dies with the
    // isolate — closing it under live watchers deadlocks, so it stays
    // unclosed.
    container.dispose();
    await tester.pump(const Duration(milliseconds: 50));
  });
}
