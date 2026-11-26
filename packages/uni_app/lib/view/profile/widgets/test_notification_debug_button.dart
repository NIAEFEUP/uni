import 'package:flutter/material.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/background_workers/notifications/test_notification.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

/// Debug controls for the notification pipeline:
///   * tap the tile to show a notification immediately, ignoring the trigger,
///     throttle and settings toggle;
///   * flip the switch to poll every [NotificationManager.debugPollPeriod]
///     instead of waiting for the hourly worker;
///   * tap the worker tile to run one regular poll, which also schedules the
///     scheduled test notification.
///
/// DEBUG: remove before merging this PR.
class TestNotificationDebugButton extends StatefulWidget {
  const TestNotificationDebugButton({super.key});

  @override
  State<TestNotificationDebugButton> createState() =>
      _TestNotificationDebugButtonState();
}

class _TestNotificationDebugButtonState
    extends State<TestNotificationDebugButton> {
  bool _pollRunning = NotificationManager.isDebugPollRunning;

  /// Keep the same instance between ticks, like the real worker does.
  final TestNotification _notification = TestNotification();

  @override
  void dispose() {
    NotificationManager.debugStopPollLoop();
    super.dispose();
  }

  Future<void> _showTestNotification() async {
    try {
      await NotificationManager.debugDisplayNotification(_notification);
    } catch (err, st) {
      debugPrint('Failed to show the test notification: $err\n$st');
      if (!mounted) {
        return;
      }
      await ToastMessage.error(context, 'Failed to show the notification.');
      return;
    }

    if (!mounted) {
      return;
    }
    await ToastMessage.info(context, 'Test notification requested.');
  }

  void _togglePoll(bool value) {
    if (value) {
      NotificationManager.startDebugPollLoop(
        buildNotification: () => _notification,
      );
    } else {
      NotificationManager.debugStopPollLoop();
    }
    setState(() => _pollRunning = value);
  }

  Future<void> _runWorkerNow() async {
    try {
      await NotificationManager.updateAndTriggerNotifications();
    } catch (err, st) {
      debugPrint('Failed to run the notification worker: $err\n$st');
      if (!mounted) {
        return;
      }
      await ToastMessage.error(context, 'Failed to run the worker.');
      return;
    }

    if (!mounted) {
      return;
    }
    await ToastMessage.info(context, 'Notification worker finished.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileListTile(
          icon: UniIcons.notification,
          title: 'Debug: test notification',
          subtitle:
              'Tap to show it now, or poll every '
              '${NotificationManager.debugPollPeriod.inSeconds}s',
          onTap: _showTestNotification,
          trailing: Switch.adaptive(
            value: _pollRunning,
            onChanged: _togglePoll,
            activeTrackColor: Theme.of(context).colorScheme.onSecondary,
            activeThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.onSecondaryFixed,
            inactiveThumbColor: Theme.of(context).colorScheme.onSecondary,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        ProfileListTile(
          icon: UniIcons.notification,
          title: 'Debug: run notification worker now',
          subtitle: 'Runs the regular poll, including the scheduled test.',
          onTap: _runWorkerNow,
        ),
      ],
    );
  }
}
