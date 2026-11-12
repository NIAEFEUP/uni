// `Notification` is hidden because Flutter has one of its own, from
// `NotificationListener`.
import 'package:flutter/material.dart' hide Notification;
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/session/flows/base/session.dart';

/// Debug-only notification for testing [ScheduledTrigger].
///
/// It's registered in `notificationMap`, so it runs through the normal worker
/// and settings. Each instance schedules itself one minute ahead and cancels
/// once that time has passed. The worker creates a new instance on every poll,
/// so it gets rescheduled each run.
// DEBUG: remove before merging this PR.
class ScheduledTestNotification extends Notification {
  ScheduledTestNotification();

  DateTime? _fireAt;

  @override
  String get uniqueID => 'scheduled-test-notification';

  @override
  String get prefsToggleKey => 'scheduled_test_notification_toogle';

  /// Off by default, so it doesn't schedule itself until you turn it on.
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
