import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/backgroundWorkers/notifications/tuition_notification.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/notification_timeout_storage.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/actions.dart';
import 'package:workmanager/workmanager.dart';

///
/// Stores all notifications that will be checked and displayed in the background. 
/// Add your custom notification here, because it will NOT be added at runtime.
/// (due to background worker limitations).
/// 
Map<Type, Notification Function()> notificationMap = {
  TuitionNotitification:() => TuitionNotitification()
};




abstract class Notification{
  
  String uniqueID;
  Duration timeout;

  Notification(this.uniqueID, this.timeout);

  Future<Tuple2<String, String>> buildNotificationContent(Session session);

  Future<bool> checkConditionToDisplay(Session session);

  void displayNotification(Tuple2<String, String> content, FlutterLocalNotificationsPlugin localNotificationsPlugin);

  Future<void> displayNotificationIfPossible(Session session, FlutterLocalNotificationsPlugin localNotificationsPlugin) async{
    bool test = await checkConditionToDisplay(session);
    Logger().d(test);
    if(test){
      displayNotification(await buildNotificationContent(session), localNotificationsPlugin);
    }
  }
}

class NotificationManager{

  static const Duration startDelay = Duration(seconds: 15);

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();



  static Future<void> tryRunAll() async{
    //first we get the .json file that contains the last time that the notification have ran
    _initFlutterNotificationsPlugin();
    final notificationStorage = await NotificationTimeoutStorage.create();
    final userInfo = await AppSharedPreferences.getPersistentUserInfo();
    final faculties = await AppSharedPreferences.getUserFaculties();
    
    final Session session =  await NetworkRouter.login(userInfo.item1, userInfo.item2, faculties, false);


    for(Notification Function() value in notificationMap.values){
        final Notification notification = value();
        final DateTime lastRan = notificationStorage.getLastTimeNotificationExecuted(notification.uniqueID);
        if(lastRan.add(notification.timeout).isBefore(DateTime.now())) {
          await notification.displayNotificationIfPossible(session, _localNotificationsPlugin);
          notificationStorage.addLastTimeNotificationExecuted(notification.uniqueID, DateTime.now());
      }
    }
  }

  //Isolates require a object as a variable on the entry function, I don't use it so it is dynamic in this case
  static void _isolateEntryFunc(dynamic message) async{

    sleep(startDelay);
    await NotificationManager.tryRunAll();
  }

  static void initializeNotifications() async{
    _initFlutterNotificationsPlugin();
    _buildNotificationWorker();
  
  }

  static void _initFlutterNotificationsPlugin() async{
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    //request for notifications immediatly on iOS
    const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    //specific to android 13+, 12 or lower is requested when the first notification channel opens
    if(Platform.isAndroid){
      final AndroidFlutterLocalNotificationsPlugin androidPlugin = _localNotificationsPlugin.resolvePlatformSpecificImplementation()!;
      try{
        final bool? permissionGranted = await androidPlugin.requestPermission();
        if(permissionGranted != true){
          //FIXME: handle this better
          throw Exception("Permission not granted for android...");
        }

      } on PlatformException catch (_){
        Logger().d("Running an android version below 13...");
      }
    
    }



  }

  static void _buildNotificationWorker() async {
    //FIXME: using initial delay to make login sequence more consistent
    //can be fixed by only using buildNotificationWorker when user is logged in
    if(Platform.isAndroid){
      Workmanager().cancelByUniqueName("pt.up.fe.ni.uni.notificationworker"); //stop task if it's already running
      Workmanager().registerPeriodicTask("pt.up.fe.ni.uni.notificationworker", "pt.up.fe.ni.uni.notificationworker", 
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(minutes: 15),
        initialDelay: startDelay,
      );

    } else if (Platform.isIOS || kIsWeb){ 
      //This is to guarentee that the notification will be run at least the app starts.
      await Isolate.spawn(_isolateEntryFunc, null);
    } else{
      throw PlatformException(code: "WorkerManager is only supported in iOS and android...");
    }

  }

}

