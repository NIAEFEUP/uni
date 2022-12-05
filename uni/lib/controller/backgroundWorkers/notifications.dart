import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
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

  static const Duration startDelay = Duration(seconds: 15);



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

  //Isolates require a object as a variable on the entry function, I don't use it so it is dynamic in this case
  static void _isolateEntryFunc(dynamic message) async{

    sleep(startDelay);
    await NotificationManager.tryRunAll();
  }

  static void buildNotificationWorker() async {
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

