// `Notification` is hidden because Flutter has one of its own, from
// `NotificationListener`.
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/background_workers/notifications/test_notification.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

/// The notification types shown in the settings.
///
/// These are the registered types, plus the debug one. The debug type is not
/// in `notificationMap`, so the background worker never sends it, but it is
/// configurable while the debug tooling is around.
// DEBUG: remove before merging this PR.
List<Notification> get settingsNotifications => [
  ...registeredNotifications,
  TestNotification(),
];

/// The toggle state of every notification type, keyed by
/// `Notification.prefsToggleKey`, plus the master switch.
class NotificationSettingsState {
  const NotificationSettingsState({
    required this.values,
    required this.masterEnabled,
  });

  final Map<String, bool> values;

  /// Whether notifications are allowed in general.
  ///
  /// This is its own setting: turning a single type on or off never changes
  /// it, and it never changes on its own either.
  final bool masterEnabled;

  /// Whether the given notification type is on.
  bool isEnabled(Notification notification) =>
      values[notification.prefsToggleKey] ?? notification.defaultEnabled;
}

/// Reads and writes the notification toggles.
///
/// The master switch is a setting of its own: it gates every notification
/// type and only changes when it is pressed. Turning one type off leaves it
/// alone.
class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsNotifier() : super(_read());

  static NotificationSettingsState _read() {
    final values = <String, bool>{};
    for (final notification in settingsNotifications) {
      values[notification.prefsToggleKey] = notification.isEnabled(
        PreferencesController.prefs,
      );
    }
    return NotificationSettingsState(
      values: values,
      masterEnabled: PreferencesController.getNotificationsToggle(),
    );
  }

  /// Turns every notification type on or off, and the master with them.
  ///
  /// Turning them off also takes down whatever is currently on screen, so
  /// the user does not keep seeing reminders they just turned off.
  Future<void> setAll(bool enabled) async {
    final notifications = settingsNotifications;
    final values = <String, bool>{};
    for (final notification in notifications) {
      await PreferencesController.prefs.setBool(
        notification.prefsToggleKey,
        enabled,
      );
      values[notification.prefsToggleKey] = enabled;
    }
    await PreferencesController.setNotificationsToggle(value: enabled);
    state = NotificationSettingsState(values: values, masterEnabled: enabled);

    if (!enabled) {
      for (final notification in notifications) {
        await _cancelSafely(() => NotificationManager.cancel(notification));
      }
    } else {
      for (final notification in notifications) {
        await _requestExactAlarmsIfNeeded(notification);
      }
    }
  }

  /// Turns a single notification type on or off.
  ///
  /// The master is left alone: it only changes when it is pressed.
  Future<void> setOne(Notification notification, bool enabled) async {
    await PreferencesController.prefs.setBool(
      notification.prefsToggleKey,
      enabled,
    );
    state = NotificationSettingsState(
      values: {...state.values, notification.prefsToggleKey: enabled},
      masterEnabled: state.masterEnabled,
    );

    if (!enabled) {
      await _cancelSafely(() => NotificationManager.cancel(notification));
    } else {
      await _requestExactAlarmsIfNeeded(notification);
    }
  }

  /// Asks for the Android exact-alarm permission when [notification] schedules
  /// itself, so enabling it does not silently downgrade the schedule.
  static Future<void> _requestExactAlarmsIfNeeded(
    Notification notification,
  ) async {
    if (notification.trigger is! ScheduledTrigger) {
      return;
    }
    final canExact = await NotificationManager.canScheduleExactNotifications();
    if (!canExact) {
      await NotificationManager.requestExactAlarmsPermission();
    }
  }

  /// Cancels what is on screen without letting a platform failure break the
  /// settings. The toggles are already stored at this point, so the user
  /// still sees the change they made.
  static Future<void> _cancelSafely(Future<void> Function() cancel) async {
    try {
      await cancel();
    } catch (err, st) {
      Logger().e(
        'Error while cancelling the notifications',
        error: err,
        stackTrace: st,
      );
    }
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<
      NotificationSettingsNotifier,
      NotificationSettingsState
    >((ref) => NotificationSettingsNotifier());

/// The switch used by every notification row, so the styling stays in one
/// place.
class _NotificationSwitch extends StatelessWidget {
  const _NotificationSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: colors.onSecondary,
      activeThumbColor: colors.secondary,
      inactiveTrackColor: colors.onSecondaryFixed,
      inactiveThumbColor: colors.onSecondary,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}

/// The master switch: it turns every notification type on or off at once.
///
/// It is shown on the settings card and on top of the notification rows, so
/// both read the same state.
class NotificationMasterSwitch extends ConsumerWidget {
  const NotificationMasterSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return _NotificationSwitch(
      value: settings.masterEnabled,
      onChanged: (value) =>
          ref.read(notificationSettingsProvider.notifier).setAll(value),
    );
  }
}

/// The switch of a single notification type.
class NotificationTypeSwitch extends ConsumerWidget {
  const NotificationTypeSwitch({super.key, required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return _NotificationSwitch(
      value: settings.isEnabled(notification),
      onChanged: (value) => ref
          .read(notificationSettingsProvider.notifier)
          .setOne(notification, value),
    );
  }
}

/// The notification settings: the master switch on top, and one switch per
/// notification type below it.
class NotificationRows extends ConsumerWidget {
  const NotificationRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = settingsNotifications;
    final settings = ref.watch(notificationSettingsProvider);

    return Column(
      children: [
        ProfileListTile(
          icon: UniIcons.notification,
          title: S.of(context).enable_notifications,
          trailing: const NotificationMasterSwitch(),
          onTap: () => ref
              .read(notificationSettingsProvider.notifier)
              .setAll(!settings.masterEnabled),
        ),
        for (final notification in notifications)
          ProfileListTile(
            icon: notification.icon,
            title: notification.userFacingTitle(context),
            trailing: NotificationTypeSwitch(notification: notification),
          ),
      ],
    );
  }
}
