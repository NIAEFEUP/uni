import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
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
};




abstract class Notification{
  
  String uniqueID;
  Duration timeout;

  Notification(this.uniqueID, this.timeout);

  Tuple2<String, String> buildNotificationContent(Session session);

  bool checkConditionToDisplay(Session session);

  void displayNotification(Tuple2<String, String> content);

  void displayNotificationIfPossible(Session session) async{
    if(checkConditionToDisplay(session)){
      displayNotification(buildNotificationContent(session));
    }
  }
}

class NotificationManager{



  static Future<void> tryRunAll() async{
    //first we get the .json file that contains the last time that the notification have ran
    final notificationStorage = await NotificationTimeoutStorage.create();
    final userInfo = await AppSharedPreferences.getPersistentUserInfo();
    final faculties = await AppSharedPreferences.getUserFaculties();
    
    final Session session =  await NetworkRouter.login(userInfo.item1, userInfo.item2, faculties, false);


    notificationMap.forEach((key, value) 
      {
        final Notification notification = value();
        final DateTime lastRan = notificationStorage.getLastTimeNotificationExecuted(notification.uniqueID);
        if(lastRan.add(notification.timeout).isBefore(DateTime.now())) {
          notification.displayNotificationIfPossible(session);
          notificationStorage.addLastTimeNotificationExecuted(notification.uniqueID, DateTime.now());
        }
      });

  }

  static void buildNotificationWorker() async {
    //FIXME: using initial delay to make login sequence more consistent
    //can be fixed by only using buildNotificationWorker when user is logged in
    if(Platform.isAndroid){
      Workmanager().cancelByUniqueName("notification-worker");
      Workmanager().cancelByUniqueName("pt.up.fe.ni.uni.notificationworker"); //stop task if it's already running
      Workmanager().registerPeriodicTask("pt.up.fe.ni.uni.notificationworker", "pt.up.fe.ni.uni.notificationworker", 
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 30),
      );

    } else if (Platform.isIOS){
      Workmanager().registerOneOffTask("pt.up.fe.ni.uni.notificationworker", "pt.up.fe.ni.uni.notificationworker", 
        constraints: Constraints(networkType: NetworkType.connected),
        initialDelay: const Duration(seconds: 30),
      );
    } else{
      throw PlatformException(code: "WorkerManager is only supported in iOS and android...");
    }

  }

}

