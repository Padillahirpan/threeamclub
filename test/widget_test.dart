import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:subuhan/main.dart';

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
        case 'getStoredAlarm':
        case 'consumeLaunchEvent':
          return null;
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

  testWidgets('spike home renders status and actions', (tester) async {
    await tester.pumpWidget(const SpikeApp());

    expect(find.text('M0 — Alarm Spike'), findsOneWidget);
    expect(find.text('No alarm stored.'), findsOneWidget);
    expect(find.text('2. Schedule alarm in 1 minute'), findsOneWidget);

    await tester.pump();
  });
}
