import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/background_workers/notifications/tuition_notification.dart';
import 'package:uni/controller/local_storage/notification_timeout_storage.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';
import 'package:workmanager/workmanager.dart';

///
/// Stores notifications that will be checked and displayed in the background.
/// Add your custom notification here, because it will NOT be added at runtime.
/// (due to background worker limitations).
///
Map<Type, Notification Function()> notificationMap = {
  TuitionNotification: TuitionNotification.new,
};

abstract class Notification {
  Notification(this.uniqueID, this.timeout);

  String uniqueID;
  Duration timeout;

  Future<Tuple2<String, String>> buildNotificationContent(Session session);

  Future<bool> shouldDisplay(Session session);

  void displayNotification(
    Tuple2<String, String> content,
    FlutterLocalNotificationsPlugin localNotificationsPlugin,
  );

  Future<void> displayNotificationIfPossible(
    Session session,
    FlutterLocalNotificationsPlugin localNotificationsPlugin,
  ) async {
    if (await shouldDisplay(session)) {
      displayNotification(
        await buildNotificationContent(session),
        localNotificationsPlugin,
      );
    }
  }
}

class NotificationManager {
  factory NotificationManager() {
    return _notificationManager;
  }

  NotificationManager._internal();

  static final NotificationManager _notificationManager =
      NotificationManager._internal();

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static const Duration _notificationWorkerPeriod = Duration(hours: 1);

  static Future<void> updateAndTriggerNotifications() async {
    PreferencesController.prefs = await SharedPreferences.getInstance();
    final userInfo = await PreferencesController.getPersistentUserInfo();
    final faculties = PreferencesController.getUserFaculties();

    if (userInfo == null || faculties.isEmpty) {
      return;
    }

    final session = await NetworkRouter.login(
      userInfo.item1,
      userInfo.item2,
      faculties,
      persistentSession: false,
    );

    if (session == null) {
      return;
    }

    // Get the .json file that contains the last time that the
    // notification has ran
    await _initFlutterNotificationsPlugin();
    final notificationStorage = await NotificationTimeoutStorage.create();

    for (final value in notificationMap.values) {
      final notification = value();
      final lastRan = notificationStorage
          .getLastTimeNotificationExecuted(notification.uniqueID);
      if (lastRan.add(notification.timeout).isBefore(DateTime.now())) {
        await notification.displayNotificationIfPossible(
          session,
          _localNotificationsPlugin,
        );
        await notificationStorage.addLastTimeNotificationExecuted(
          notification.uniqueID,
          DateTime.now(),
        );
      }
    }
  }

  Future<void> initializeNotifications() async {
    // guarantees that the execution is only done
    // once in the lifetime of the app.
    if (_initialized) {
      return;
    }
    _initialized = true;
    await _initFlutterNotificationsPlugin();
    await _buildNotificationWorker();
  }

  static Future<void> _initFlutterNotificationsPlugin() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    //request for notifications immediatly on iOS
    const darwinInitializationSettings = DarwinInitializationSettings(
      requestCriticalPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    // specific to android 13+, 12 or lower permission is requested when
    // the first notification channel opens
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!;
      try {
        final permissionGranted = await androidPlugin.requestPermission();
        if (permissionGranted != true) {
          return;
        }
      } on PlatformException catch (_) {}
    }
  }

  static Future<void> _buildNotificationWorker() async {
    if (Platform.isAndroid) {
      await Workmanager().cancelByUniqueName(
        'pt.up.fe.ni.uni.notificationworker',
      ); //stop task if it's already running
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
}
