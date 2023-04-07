import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/background_workers/notifications/tuition_notification.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/notification_timeout_storage.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';
import 'package:workmanager/workmanager.dart';

///
/// Stores all notifications that will be checked and displayed in the background.
/// Add your custom notification here, because it will NOT be added at runtime.
/// (due to background worker limitations).
///
Map<Type, Notification Function()> notificationMap = {
  TuitionNotification: () => TuitionNotification(),
};

abstract class Notification {
  String uniqueID;
  Duration timeout;

  Notification(this.uniqueID, this.timeout);

  Future<Tuple2<String, String>> buildNotificationContent(Session session);

  Future<bool> shouldDisplay(Session session);

  void displayNotification(Tuple2<String, String> content,
      FlutterLocalNotificationsPlugin localNotificationsPlugin);

  Future<void> displayNotificationIfPossible(Session session,
      FlutterLocalNotificationsPlugin localNotificationsPlugin) async {
    if (await shouldDisplay(session)) {
      displayNotification(
          await buildNotificationContent(session), localNotificationsPlugin);
    }
  }
}

class NotificationManager {
  static final NotificationManager _notificationManager =
      NotificationManager._internal();

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static const Duration _notificationWorkerPeriod = Duration(hours: 1);

  factory NotificationManager() {
    return _notificationManager;
  }

  static Future<void> updateAndTriggerNotifications() async {
    //first we get the .json file that contains the last time that the notification have ran
    _initFlutterNotificationsPlugin();
    final notificationStorage = await NotificationTimeoutStorage.create();
    final userInfo = await AppSharedPreferences.getPersistentUserInfo();
    final faculties = await AppSharedPreferences.getUserFaculties();

    final Session session = await NetworkRouter.login(
        userInfo.item1, userInfo.item2, faculties, false);

    for (Notification Function() value in notificationMap.values) {
      final Notification notification = value();
      final DateTime lastRan = notificationStorage
          .getLastTimeNotificationExecuted(notification.uniqueID);
      if (lastRan.add(notification.timeout).isBefore(DateTime.now())) {
        await notification.displayNotificationIfPossible(
            session, _localNotificationsPlugin);
        await notificationStorage.addLastTimeNotificationExecuted(
            notification.uniqueID, DateTime.now());
      }
    }
  }

  void initializeNotifications() async {
    //guarentees that the execution is only done once in the lifetime of the app.
    if (_initialized) return;
    _initialized = true;
    _initFlutterNotificationsPlugin();
    _buildNotificationWorker();
  }

  static void _initFlutterNotificationsPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    //request for notifications immediatly on iOS
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestCriticalPermission: true);

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: darwinInitializationSettings,
            macOS: darwinInitializationSettings);

    await _localNotificationsPlugin.initialize(initializationSettings);

    //specific to android 13+, 12 or lower permission is requested when the first notification channel opens
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin androidPlugin =
          _localNotificationsPlugin.resolvePlatformSpecificImplementation()!;
      try {
        final bool? permissionGranted = await androidPlugin.requestPermission();
        if (permissionGranted != true) {
          return;
        }
      } on PlatformException catch (_) {}
    }
  }

  NotificationManager._internal();

  static void _buildNotificationWorker() async {
    if (Platform.isAndroid) {
      Workmanager().cancelByUniqueName(
          "pt.up.fe.ni.uni.notificationworker"); //stop task if it's already running
      Workmanager().registerPeriodicTask(
        "pt.up.fe.ni.uni.notificationworker",
        "pt.up.fe.ni.uni.notificationworker",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: _notificationWorkerPeriod,
      );
    } else if (Platform.isIOS || kIsWeb) {
      //This is to guarentee that the notification will be run at least the app starts.
      //NOTE (luisd): This is not an isolate because we can't register plugins in a isolate, in the current version of flutter
      //  so we just do it after login
      Logger().d("Running notification worker on main isolate...");
      await updateAndTriggerNotifications();
      Timer.periodic(_notificationWorkerPeriod, (timer) {
        Logger().d("Running notification worker on periodic timer...");
        updateAndTriggerNotifications();
      });
    } else {
      throw PlatformException(
          code: "WorkerManager is only supported in iOS and android...");
    }
  }
}
