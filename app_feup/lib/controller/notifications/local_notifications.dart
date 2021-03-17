import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin _instance;
  
  static start() {
    // Ensure binary messenger has been initialized
    // Should it stay here or move to main()/onStart()?
    WidgetsFlutterBinding.ensureInitialized();

    // Create notification plugin instance
    _instance = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
    );
    _instance.initialize(initializationSettings);
  }
  
  static pushNotification({@required String title, @required String body, String payload}) {
    const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'uni', 'uNi', 'Notifications for uNi by NIAEFEUP',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false,
      );
    const NotificationDetails platformSpecificDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _instance.show(
      0, title, body, platformSpecificDetails,
      payload: payload
    );
  }
}