import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/background_workers/notifications/test_notification.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

/// Debug-only controls for the notification pipeline:
///   * tap the tile to display a notification immediately, ignoring the
///     trigger, the throttle and the settings toggle;
///   * flip the switch to run the regular poll every
///     [NotificationManager.debugPollPeriod], so trigger/throttle behaviour can
///     be observed without waiting for the hourly worker.
///
/// WARN: Remove this widget before merging to develop.
class TestNotificationDebugButton extends StatefulWidget {
  const TestNotificationDebugButton({super.key});

  @override
  State<TestNotificationDebugButton> createState() =>
      _TestNotificationDebugButtonState();
}

class _TestNotificationDebugButtonState
    extends State<TestNotificationDebugButton> {
  bool _pollRunning = NotificationManager.isDebugPollRunning;

  /// Kept across ticks so `hasFired` state behaves like the real worker.
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

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    return ProfileListTile(
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
    );
  }
}
