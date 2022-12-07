

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'package:uni/controller/backgroundWorkers/notifications.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/model/entities/session.dart';

class TuitionNotitification extends Notification{
  late DateTime _dueDate;

  TuitionNotitification() : super("tuition-notification", const Duration(hours: 12));

  @override
  Future<Tuple2<String, String>> buildNotificationContent(Session session) async {
    if(_dueDate.isBefore(DateTime.now())){
      final int days = DateTime.now().difference(_dueDate).inDays;
      return Tuple2("⚠️ Ainda não pagaste as propinas ⚠️", "Já passaram $days dias desde do dia limite");
    }
    final int days = _dueDate.difference(DateTime.now()).inDays;
    return Tuple2("O prazo limite para as propinas está a acabar", "Faltam $days dias para o prazo acabar");
    
  }

  @override
  Future<bool> checkConditionToDisplay(Session session) async {
    final FeesFetcher feesFetcher = FeesFetcher();
    final String nextDueDate = await parseFeesNextLimit(await feesFetcher.getUserFeesResponse(session));
    _dueDate = DateTime.parse(nextDueDate);
    if(DateTime.now().difference(_dueDate).inDays >= -3){
      return true;
    }
    return false;
  }

  @override
  void displayNotification(Tuple2<String, String> content, FlutterLocalNotificationsPlugin localNotificationsPlugin) {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "propinas-notificacao", "propinas-notificacao", 
      importance: Importance.high);
    
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    localNotificationsPlugin.show(2, content.item1, content.item2, notificationDetails);
  }

}