import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:uni/controller/background_workers/notifications/tuition_notification.dart';
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
  TuitionNotification: TuitionNotification.new,
};

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

  NotificationDetails toDetails({
    NotificationImage? image,
    NotificationGroup? group,
  }) {
    final android = AndroidNotificationDetails(
      androidId,
      androidName,
      importance: androidImportance,
      largeIcon: image?.toAndroidBitmap(),
      groupKey: group?.groupKey,
      setAsGroupSummary: group?.isSummary ?? false,
    );

    final darwin = DarwinNotificationDetails(
      presentAlert: presentAlert,
      presentBadge: presentBadge,
      presentSound: presentSound,
      interruptionLevel: interruptionLevel,
      threadIdentifier: group?.groupKey,
      attachments: image?.toDarwinAttachments(),
    );

    return NotificationDetails(android: android, iOS: darwin);
  }
}

/// Image attached to a notification. Has to be a resource, a file or raw bytes. Choose from the classes below.
sealed class NotificationImage {
  const NotificationImage();

  AndroidBitmap<Object>? toAndroidBitmap();

  List<DarwinNotificationAttachment>? toDarwinAttachments();
}

/// Android drawable resource
class DrawableNotificationImage extends NotificationImage {
  const DrawableNotificationImage(this.name);

  final String name;

  @override
  AndroidBitmap<Object> toAndroidBitmap() =>
      DrawableResourceAndroidBitmap(name);

  @override
  List<DarwinNotificationAttachment>? toDarwinAttachments() => null;
}

/// Image stored in the file system.
class FileNotificationImage extends NotificationImage {
  const FileNotificationImage(this.path);

  final String path;

  @override
  AndroidBitmap<Object> toAndroidBitmap() => FilePathAndroidBitmap(path);

  @override
  List<DarwinNotificationAttachment>? toDarwinAttachments() => [
    DarwinNotificationAttachment(path),
  ];
}

/// Image as raw bytes (PNG).
class BytesNotificationImage extends NotificationImage {
  const BytesNotificationImage(this.bytes);

  final Uint8List bytes;

  @override
  AndroidBitmap<Object> toAndroidBitmap() => ByteArrayAndroidBitmap(bytes);

  @override
  List<DarwinNotificationAttachment>? toDarwinAttachments() => null;
}

/// Groups notifications of the same kind (Android group + summary,
/// iOS thread identifier).
class NotificationGroup {
  const NotificationGroup({required this.groupKey, this.isSummary = false});

  final String groupKey;
  final bool isSummary;
}

/// How the platform notification id is chosen.
sealed class NotificationIdStrategy {
  const NotificationIdStrategy();
}

/// The notification keeps a stable platform id — re-showing replaces the
/// previous one ("update in place").
class FixedNotificationId extends NotificationIdStrategy {
  const FixedNotificationId(this.id);

  final int id;
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

  NotificationIdStrategy get idStrategy;

  NotificationTrigger get trigger;

  NotificationImage? get image => null;

  NotificationGroup? get group => null;

  /// Time-to-live after firing; `null` keeps the notification until the user
  /// dismisses it. Expiry is enforced on the next poll (may be late by up to
  /// one poll period).
  Duration? get ttl => null;

  /// Builds the notification text - must be dynamic and locale aware.
  Future<(String, String)> buildContent(Session session);

  /// Platform id (from [idStrategy]).
  int get id => switch (idStrategy) {
    FixedNotificationId(:final id) => id,
  };

  /// Whether the user allowed this type in settings.
  bool isEnabled(SharedPreferences prefs) =>
      prefs.getBool(prefsToggleKey) ?? defaultEnabled;

  NotificationDetails get details =>
      channel.toDetails(image: image, group: group);

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
  // WARN: Remove this method before merging to develop.
  static const debugPollPeriod = Duration(seconds: 30);

  // WARN: Remove this field before merging to develop.
  static Timer? _debugPollTimer;

  /// Whether the debug poll loop is currently running.
  // WARN: Remove this method before merging to develop.
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

  static Future<void> _ensurePluginInitialized() async {
    if (_pluginInitialized) {
      return;
    }
    _pluginInitialized = true;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
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

  /// Displays [notification] immediately, ignoring its trigger, its throttle
  /// and the user toggle. Only meant for debugging the notification pipeline.
  // WARN: Remove this method before merging to develop.
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

  /// Runs the regular [updateAndTriggerNotifications] every [debugPollPeriod]
  /// instead of waiting for the hourly worker, so trigger/throttle behaviour
  /// can be observed without waiting an hour between checks.
  ///
  /// [buildNotification] is called on every tick, so stateful notifications
  /// (such as `TestNotification.hasFired`) keep their state across polls.
  // WARN: Remove this method before merging to develop.
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

  /// Runs a single poll of [notification] through the regular pipeline:
  /// the settings toggle, the TTL, the throttle and the trigger are all
  /// respected, unlike [debugDisplayNotification].
  // WARN: Remove this method before merging to develop.
  static Future<void> debugPollOnce(Notification notification) async {
    PreferencesController.prefs = await SharedPreferences.getInstance();

    final savedSession = await PreferencesController.getSavedSession();
    if (savedSession == null) {
      throw StateError('Cannot poll ${notification.uniqueID}: no session.');
    }

    final session = await savedSession.createRefreshRequest().perform();

    await _ensurePluginInitialized();
    final notificationStorage = await NotificationTimeoutStorage.create();

    await _processNotification(notification, session, notificationStorage);
  }

  // WARN: Remove this method before merging to develop.
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
        if (fireTime == null) {
          await _localNotificationsPlugin.cancel(id: notification.id);
          return;
        }
        final content = await notification.buildContent(session);
        await _localNotificationsPlugin.zonedSchedule(
          id: notification.id,
          scheduledDate: tz.TZDateTime.from(fireTime, tz.local),
          notificationDetails: notification.details,
          androidScheduleMode: allowWhileIdle
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.exact,
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
}
