// `Notification` is hidden because Flutter has one of its own, from
// `NotificationListener`.
import 'package:flutter/material.dart' hide Notification;
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/session/flows/base/session.dart';

// DEBUG: remove before merging this PR.
class TestNotification extends Notification {
  TestNotification();

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
  int get id => 3;

  @override
  String userFacingTitle(BuildContext context) => 'Test notification (debug)';

  @override
  IconData get icon => Icons.bug_report_outlined;

  // Shorter than the debug poll loop period, so every tick can fire.
  @override
  NotificationTrigger get trigger => PollTrigger(
    throttle: const Duration(seconds: 10),
    shouldFire: _shouldFire,
  );

  Future<bool> _shouldFire(Session session, DateTime now) async {
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
