// `Notification` is hidden because Flutter has one of its own, from
// `NotificationListener`.
import 'package:flutter/material.dart' hide Notification;
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/session/flows/base/session.dart';

/// Debug-only notification that exercises the [ScheduledTrigger] path.
///
/// It is registered in `notificationMap`, so it goes through the regular
/// worker, the settings toggles and the timeout storage. The first poll of an
/// instance schedules it one minute ahead; polling the same instance again
/// keeps that target, and cancels the notification once it has passed. The
/// background worker creates a fresh instance on every poll, so each run
/// schedules it again.
// DEBUG: remove before merging this PR.
class ScheduledTestNotification extends Notification {
  ScheduledTestNotification();

  DateTime? _fireAt;

  @override
  String get uniqueID => 'scheduled-test-notification';

  @override
  String get prefsToggleKey => 'scheduled_test_notification_toogle';

  /// Disabled by default, so a debug build does not schedule it until the
  /// tester explicitly turns it on.
  @override
  bool get defaultEnabled => false;

  @override
  NotificationChannel get channel => const NotificationChannel(
    androidId: 'scheduled-test-notificacao',
    androidName: 'scheduled-test-notificacao',
  );

  @override
  int get id => 5;

  @override
  String userFacingTitle(BuildContext context) =>
      'Scheduled test notification (debug)';

  @override
  IconData get icon => Icons.schedule_outlined;

  @override
  NotificationTrigger get trigger =>
      ScheduledTrigger(nextFireTime: _nextFireTime);

  Future<DateTime?> _nextFireTime(Session session) async {
    final fireAt = _fireAt ??= DateTime.now().add(const Duration(minutes: 1));
    if (fireAt.isBefore(DateTime.now())) {
      return null;
    }
    return fireAt;
  }

  @override
  Future<(String, String)> buildContent(Session session) async {
    return const (
      'Notificação agendada de teste',
      'Se estás a ver isto, o agendamento funcionou.',
    );
  }
}
