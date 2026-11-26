import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Notification;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:uni/controller/background_workers/notifications/scheduled_test_notification.dart';
import 'package:uni/controller/background_workers/notifications/test_notification.dart';
import 'package:uni/controller/local_storage/notification_timeout_storage.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:workmanager/workmanager.dart';

///
/// Stores notifications that will be checked and displayed in the background.
/// Add your custom notification here, because it will NOT be added at runtime.
/// (due to background worker limitations).
///
Map<Type, Notification Function()> notificationMap = {
  // DEBUG: remove before merging this PR.
  ScheduledTestNotification: ScheduledTestNotification.new,
};

/// Every notification type the app can send, in registration order.
///
/// The settings screen uses this to build one toggle per type. A type that
/// isn't in [notificationMap] is never sent, so it doesn't get a toggle.
List<Notification> get registeredNotifications =>
    notificationMap.values.map((factory) => factory()).toList();

// ---------------------------------------------------------------------------
// Shared value types
// ---------------------------------------------------------------------------

/// Android channel + Darwin presentation settings shared by every platform
/// variant of a notification.
class NotificationChannel {
  const NotificationChannel({
    required this.androidId,
    required this.androidName,
    this.androidImportance = Importance.high,
    this.presentAlert = true,
    this.presentBadge = true,
    this.presentSound = true,
    this.interruptionLevel,
  });

  final String androidId;
  final String androidName;
  final Importance androidImportance;
  final bool presentAlert;
  final bool presentBadge;
  final bool presentSound;
  final InterruptionLevel? interruptionLevel;

  /// Notification details shared by both platforms.
  NotificationDetails toDetails() {
    final android = AndroidNotificationDetails(
      androidId,
      androidName,
      importance: androidImportance,
    );

    final darwin = DarwinNotificationDetails(
      presentAlert: presentAlert,
      presentBadge: presentBadge,
      presentSound: presentSound,
      interruptionLevel: interruptionLevel,
    );

    return NotificationDetails(android: android, iOS: darwin);
  }
}

// ---------------------------------------------------------------------------
// Triggers
// ---------------------------------------------------------------------------

/// Decides when a notification pops up.
sealed class NotificationTrigger {
  const NotificationTrigger();
}

/// Checked on every background poll; [throttle] limits how often the check
/// runs (not how often the notification is displayed).
class PollTrigger extends NotificationTrigger {
  const PollTrigger({required this.shouldFire, required this.throttle});

  /// Decides whether the notification should pop up right now.
  final Future<bool> Function(Session session, DateTime now) shouldFire;

  /// Minimum time between two checks.
  final Duration throttle;
}

/// Fires at an exact [DateTime], no poll check.
class ScheduledTrigger extends NotificationTrigger {
  const ScheduledTrigger({
    required this.nextFireTime,
    this.allowWhileIdle = true,
  });

  /// Next time the notification should fire; `null` cancels the pending one.
  final Future<DateTime?> Function(Session session) nextFireTime;

  final bool allowWhileIdle;
}

// ---------------------------------------------------------------------------
// Notification
// ---------------------------------------------------------------------------

abstract class Notification {
  /// Stable identifier: timeout-storage key, logging, registry.
  String get uniqueID;

  /// SharedPreferences key of the user-facing toggle for this type.
  String get prefsToggleKey;

  /// Value used when [prefsToggleKey] was never written.
  bool get defaultEnabled;

  NotificationChannel get channel;

  /// Platform notification id. Showing another notification with the same id
  /// replaces this one.
  int get id;

  NotificationTrigger get trigger;

  /// Time-to-live after firing; `null` keeps the notification until the user
  /// dismisses it. Expiry is enforced on the next poll (may be late by up to
  /// one poll period).
  Duration? get ttl => null;

  /// Builds the notification text - must be dynamic and locale aware.
  Future<(String, String)> buildContent(Session session);

  /// Name shown in the settings for this notification type.
  ///
  /// Resolved with a `BuildContext`, so it's only available in the UI isolate.
  String userFacingTitle(BuildContext context);

  /// Icon shown in the settings for this notification type.
  IconData get icon;

  /// Whether the user allowed this type in settings.
  bool isEnabled(SharedPreferences prefs) =>
      prefs.getBool(prefsToggleKey) ?? defaultEnabled;

  NotificationDetails get details => channel.toDetails();

  /// Shows (or replaces, for fixed ids) the notification.
  Future<void> display(
    (String, String) content,
    FlutterLocalNotificationsPlugin localNotificationsPlugin,
  ) {
    return localNotificationsPlugin.show(
      id: id,
      title: content.$1,
      body: content.$2,
      notificationDetails: details,
    );
  }
}

// ---------------------------------------------------------------------------
// Manager
// ---------------------------------------------------------------------------

class NotificationManager {
  factory NotificationManager() {
    return _notificationManager;
  }

  NotificationManager._internal();

  static final _notificationManager = NotificationManager._internal();

  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static var _initialized = false;

  static var _pluginInitialized = false;

  static var _timeZonesInitialized = false;

  static const _notificationWorkerPeriod = Duration(hours: 1);

  /// How often the debug poll loop below checks the notification.
  // DEBUG: remove before merging this PR.
  static const debugPollPeriod = Duration(seconds: 30);

  // DEBUG: remove before merging this PR.
  static Timer? _debugPollTimer;

  /// Whether the debug poll loop is currently running.
  // DEBUG: remove before merging this PR.
  static bool get isDebugPollRunning => _debugPollTimer != null;

  Future<void> initializeNotifications() async {
    // guarantees that the execution is only done
    // once in the lifetime of the app.
    if (_initialized) {
      return;
    }
    await _ensurePluginInitialized();
    await _buildNotificationWorker();
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  Future<bool> hasNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (status.isGranted || status.isProvisional) {
        return true;
      }

      if (Platform.isAndroid) {
        final androidPlugin = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final bool? enabled = await androidPlugin?.areNotificationsEnabled();
        return enabled ?? true;
      }

      if (Platform.isIOS) {
        final iosPlugin = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final settings = await iosPlugin?.checkPermissions();
        return settings?.isAlertEnabled ?? false;
      }

      if (status.isDenied ||
          status.isPermanentlyDenied ||
          status.isRestricted) {
        return false;
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> canScheduleExactNotifications() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  static Future<bool> requestExactAlarmsPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await androidPlugin?.requestExactAlarmsPermission() ?? false;
  }

  static Future<void> _ensurePluginInitialized() async {
    if (_pluginInitialized) {
      return;
    }

    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_launcher_monochrome',
    );

    // iOS
    const darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: darwinInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
    _pluginInitialized = true;
  }

  static Future<void> _ensureTimeZonesInitialized() async {
    if (_timeZonesInitialized) {
      return;
    }
    _timeZonesInitialized = true;
    tz_data.initializeTimeZones();
    // NOTE: `tz.local` defaults to UTC. For one-shot schedules this is fine
    // (only the instant matters); revisit when repeating schedules land.
  }

  static Future<void> _buildNotificationWorker() async {
    if (Platform.isAndroid) {
      await Workmanager().cancelByUniqueName(
        'pt.up.fe.ni.uni.notificationworker',
      ); // stop task if it's already running
      await Workmanager().registerPeriodicTask(
        'pt.up.fe.ni.uni.notificationworker',
        'pt.up.fe.ni.uni.notificationworker',
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: _notificationWorkerPeriod,
      );
    } else if (Platform.isIOS || kIsWeb) {
      // This is to guarantee that the notification
      // will be run at least once the app starts.
      // NOTE (luisd): This is not an isolate because we can't register plugins
      // in a isolate, in the current version of flutter
      // so we just do it after login
      Logger().d('Running notification worker on main isolate...');
      await updateAndTriggerNotifications();
      Timer.periodic(_notificationWorkerPeriod, (timer) {
        Logger().d('Running notification worker on periodic timer...');
        updateAndTriggerNotifications();
      });
    } else {
      throw PlatformException(
        code: 'WorkerManager is only supported in iOS and android...',
      );
    }
  }

  /// Cancels [notification] if it's currently shown.
  ///
  /// Called when the user turns a type off, so it disappears right away instead
  /// of hanging around until its TTL expires.
  static Future<void> cancel(Notification notification) async {
    await _ensurePluginInitialized();
    await _localNotificationsPlugin.cancel(id: notification.id);
  }

  /// Shows [notification] immediately, ignoring its trigger, throttle and the
  /// settings toggle. Only for debugging the notification pipeline.
  // DEBUG: remove before merging this PR.
  static Future<void> debugDisplayNotification(
    Notification notification,
  ) async {
    await _ensurePluginInitialized();

    final session = await PreferencesController.getSavedSession();
    if (session == null) {
      throw StateError(
        'Cannot build the content of ${notification.uniqueID}: no saved '
        'session.',
      );
    }

    await notification.display(
      await notification.buildContent(session),
      _localNotificationsPlugin,
    );
  }

  /// Runs the normal poll every [debugPollPeriod] instead of hourly, so
  /// triggers and throttles can be tested without waiting an hour.
  ///
  /// [buildNotification] is called on every tick, so stateful notifications
  /// keep their state across polls.
  // DEBUG: remove before merging this PR.
  static void startDebugPollLoop({
    required Notification Function() buildNotification,
  }) {
    debugStopPollLoop();
    _debugPollTimer = Timer.periodic(debugPollPeriod, (_) async {
      try {
        await debugPollOnce(buildNotification());
      } catch (err, st) {
        Logger().e(
          'Error while running the debug notification poll',
          error: err,
          stackTrace: st,
        );
      }
    });
  }

  /// Runs one poll of [notification] through the normal pipeline, so the
  /// settings toggle, TTL, throttle and trigger all apply. This is unlike
  /// [debugDisplayNotification], which skips them.
  // DEBUG: remove before merging this PR.
  static Future<void> debugPollOnce(Notification notification) async {
    PreferencesController.prefs = await SharedPreferences.getInstance();

    final savedSession = await PreferencesController.getSavedSession();
    if (savedSession == null) {
      throw StateError('Cannot poll ${notification.uniqueID}: no session.');
    }

    final session = await savedSession.createRefreshRequest().perform();

    await _ensurePluginInitialized();
    final notificationStorage = await NotificationTimeoutStorage.create();

    _assertIdSpacesAreDisjoint();

    await _processNotification(notification, session, notificationStorage);
  }

  // DEBUG: remove before merging this PR.
  static void debugStopPollLoop() {
    _debugPollTimer?.cancel();
    _debugPollTimer = null;
  }

  static Future<void> updateAndTriggerNotifications() async {
    PreferencesController.prefs = await SharedPreferences.getInstance();
    final savedSession = await PreferencesController.getSavedSession();

    if (savedSession == null) {
      return;
    }

    final request = savedSession.createRefreshRequest();
    final session = await request.perform();

    // The plugin must be initialized in every isolate that may run this
    // (Android Workmanager runs it in a fresh isolate when the app is
    // terminated, where `initializeNotifications` never ran).
    await _ensurePluginInitialized();
    final notificationStorage = await NotificationTimeoutStorage.create();

    _assertIdSpacesAreDisjoint();

    for (final value in notificationMap.values) {
      final notification = value();
      try {
        await _processNotification(notification, session, notificationStorage);
      } catch (err, st) {
        Logger().e(
          'Error while checking notification ${notification.uniqueID}',
          error: err,
          stackTrace: st,
        );
      }
    }
  }

  static Future<void> _processNotification(
    Notification notification,
    Session session,
    NotificationTimeoutStorage notificationStorage,
  ) async {
    // The master switch gates every type on top of its own toggle. Turning one
    // type off doesn't change the master.
    if (!PreferencesController.getNotificationsToggle()) {
      await cancel(notification);
      return;
    }

    final now = DateTime.now();

    // TTL expiry (poll-side): cancel anything whose time-to-live elapsed.
    final ttl = notification.ttl;
    if (ttl != null) {
      final firedAt = notificationStorage.getLastTimeNotificationFired(
        notification.uniqueID,
      );
      if (firedAt != null && firedAt.add(ttl).isBefore(now)) {
        await _localNotificationsPlugin.cancel(id: notification.id);
        await notificationStorage.clearLastTimeNotificationFired(
          notification.uniqueID,
        );
      }
    }

    // Disabled via the settings toggle: nothing to fire, and any pending
    // scheduled notification must be cancelled.
    if (!notification.isEnabled(PreferencesController.prefs)) {
      if (notification.trigger case ScheduledTrigger()) {
        await _localNotificationsPlugin.cancel(id: notification.id);
      }
      return;
    }

    switch (notification.trigger) {
      case PollTrigger(:final shouldFire, :final throttle):
        final lastRan = notificationStorage.getLastTimeNotificationExecuted(
          notification.uniqueID,
        );
        if (!lastRan.add(throttle).isBefore(now)) {
          return;
        }
        try {
          if (await shouldFire(session, now)) {
            final content = await notification.buildContent(session);
            await notification.display(content, _localNotificationsPlugin);
            if (ttl != null) {
              await notificationStorage.setLastTimeNotificationFired(
                notification.uniqueID,
                now,
              );
            }
          }
        } finally {
          // Record the check even when it failed or was suppressed, matching
          // the previous behaviour (avoids hammering the API on errors).
          await notificationStorage.addLastTimeNotificationExecuted(
            notification.uniqueID,
            now,
          );
        }
      case ScheduledTrigger(:final nextFireTime, :final allowWhileIdle):
        await _ensureTimeZonesInitialized();
        final fireTime = await nextFireTime(session);
        if (fireTime == null || fireTime.isBefore(now)) {
          await _localNotificationsPlugin.cancel(id: notification.id);
          return;
        }

        var scheduleMode = allowWhileIdle
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.exact;
        if (Platform.isAndroid) {
          final canExact = await canScheduleExactNotifications();
          if (!canExact) {
            scheduleMode = allowWhileIdle
                ? AndroidScheduleMode.inexactAllowWhileIdle
                : AndroidScheduleMode.inexact;
          }
        }

        final content = await notification.buildContent(session);
        await _localNotificationsPlugin.zonedSchedule(
          id: notification.id,
          scheduledDate: tz.TZDateTime.from(fireTime, tz.local),
          notificationDetails: notification.details,
          androidScheduleMode: scheduleMode,
          title: content.$1,
          body: content.$2,
        );
        if (ttl != null) {
          await notificationStorage.setLastTimeNotificationFired(
            notification.uniqueID,
            fireTime,
          );
        }
    }
  }

  /// Debug-only check for duplicate platform notification ids.
  ///
  /// Ids are assigned by hand, so a typo could make one notification silently
  /// replace another. Settings-only types are included because they still use
  /// their id.
  static void _assertIdSpacesAreDisjoint() {
    assert(() {
      final fixedIds = <int, String>{};

      // DEBUG: remove the debug entry before merging this PR.
      final notifications = [...registeredNotifications, TestNotification()];

      for (final notification in notifications) {
        assert(
          !fixedIds.containsKey(notification.id),
          'The notification id ${notification.id} is used by both '
          '${fixedIds[notification.id]} and ${notification.uniqueID}.',
        );
        fixedIds[notification.id] = notification.uniqueID;
      }

      return true;
    }());
  }
}
