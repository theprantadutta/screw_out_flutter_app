import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/services/analytics/analytics.dart';
import 'package:screw_out/services/test_lab_detector.dart';

class _FakeClient implements AnalyticsClient {
  @override
  void track(String event, Map<String, Object?> params) {}

  @override
  void screen(String name) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('screw_out/test_lab_under_test');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  var calls = 0;
  void answer(Object? Function(MethodCall call) reply) {
    calls = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls++;
      return reply(call);
    });
  }

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  group('TestLabDetector', () {
    test('uses the channel MainActivity registers', () {
      expect(TestLabDetector.defaultChannel.name, 'screw_out/test_lab');
    });

    test('Android: true when the native side reports a Test Lab device', () async {
      answer((call) => call.method == 'isTestLab');
      expect(await TestLabDetector(channel: channel, isAndroid: true).isTestLab(), isTrue);
    });

    test('Android: false on a real device', () async {
      answer((_) => false);
      expect(await TestLabDetector(channel: channel, isAndroid: true).isTestLab(), isFalse);
    });

    test('asks the platform once per launch', () async {
      answer((_) => true);
      final detector = TestLabDetector(channel: channel, isAndroid: true);
      await detector.isTestLab();
      await detector.isTestLab();
      expect(calls, 1);
    });

    test('a channel error or a missing handler never marks a real player as a robot', () async {
      answer((_) => throw PlatformException(code: 'boom'));
      expect(await TestLabDetector(channel: channel, isAndroid: true).isTestLab(), isFalse);

      messenger.setMockMethodCallHandler(channel, null);
      expect(await TestLabDetector(channel: channel, isAndroid: true).isTestLab(), isFalse);
    });

    test('iOS and other platforms: always false, the channel is never asked', () async {
      answer((_) => true);
      expect(await TestLabDetector(channel: channel, isAndroid: false).isTestLab(), isFalse);
      expect(calls, 0);
    });
  });

  group('platformAnalyticsClients', () {
    AnalyticsClient fake() => _FakeClient();

    test('release on a real device: Firebase', () {
      final clients = platformAnalyticsClients(debug: false, firebase: true, testLab: false, firebaseClient: fake);
      expect(clients, hasLength(1));
      expect(clients.single, isA<_FakeClient>());
    });

    test('release on a Test Lab robot: no Firebase client', () {
      expect(platformAnalyticsClients(debug: false, firebase: true, testLab: true, firebaseClient: fake), isEmpty);
    });

    test('Firebase unavailable: nothing', () {
      expect(platformAnalyticsClients(debug: false, firebase: false, testLab: false, firebaseClient: fake), isEmpty);
    });

    test('debug: console only', () {
      final clients = platformAnalyticsClients(debug: true, firebase: true, testLab: false, firebaseClient: fake);
      expect(clients.single, isA<DebugAnalyticsClient>());
    });
  });
}
