import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/session/flows/base/session.dart';

// WARN: Remove this class before merging to develop.
class TestNotification extends Notification {
  TestNotification();

  bool hasFired = false;

  @override
  String get uniqueID => 'test-notification';

  @override
  String get prefsToggleKey => 'test_notification_toogle';

  @override
  bool get defaultEnabled => true;

  @override
  NotificationChannel get channel => const NotificationChannel(
    androidId: 'test-notificacao',
    androidName: 'test-notificacao',
  );

  @override
  NotificationIdStrategy get idStrategy => const FixedNotificationId(3);

  // Shorter than the debug poll loop period, so every tick can fire.
  @override
  NotificationTrigger get trigger => PollTrigger(
    throttle: const Duration(seconds: 10),
    shouldFire: _shouldFire,
  );

  Future<bool> _shouldFire(Session session, DateTime now) async {
    hasFired = true;
    return true;
  }

  @override
  Future<(String, String)> buildContent(Session session) async {
    return const (
      'Isto é uma notificação de teste.',
      'Se estás a ver isto é porque funcionou.',
    );
  }
}
