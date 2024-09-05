import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/duration_string_formatter.dart';

class TuitionNotification extends Notification {
  TuitionNotification()
      : super('tuition-notification', const Duration(hours: 12));
  late DateTime _dueDate;

  @override
  Future<Tuple2<String, String>> buildNotificationContent(
    Session session,
  ) async {
    // We must add one day because the time limit is actually at 23:59 and
    // not at 00:00 of the same day
    if (_dueDate.add(const Duration(days: 1)).isBefore(DateTime.now())) {
      final duration = DateTime.now().difference(_dueDate);
      if (duration.inDays == 0) {
        return const Tuple2(
          '⚠️ Ainda não pagaste as propinas ⚠️',
          'O prazo para pagar as propinas acabou ontem',
        );
      }
      return Tuple2(
        '⚠️ Ainda não pagaste as propinas ⚠️',
        duration.toFormattedString(
          'Já passou {} desde a data limite',
          'Já passaram {} desde a data limite',
        ),
      );
    }
    final duration = _dueDate.difference(DateTime.now());
    if (duration.inDays == 0) {
      return const Tuple2(
        'O prazo limite para as propinas está a acabar',
        'Hoje acaba o prazo para pagamento das propinas!',
      );
    }
    return Tuple2(
      'O prazo limite para as propinas está a acabar',
      duration.toFormattedString(
        'Falta {} para a data limite',
        'Faltam {} para a data limite',
      ),
    );
  }

  @override
  Future<bool> shouldDisplay(Session session) async {
    final notificationsAreDisabled =
        !PreferencesController.getTuitionNotificationToggle();
    if (notificationsAreDisabled) {
      return false;
    }
    final feesFetcher = FeesFetcher();
    final dueDate = parseFeesNextLimit(
      await feesFetcher.getUserFeesResponse(session),
    );

    if (dueDate == null) {
      return false;
    }

    _dueDate = dueDate;
    return DateTime.now().difference(_dueDate).inDays >= -3;
  }

  @override
  void displayNotification(
    Tuple2<String, String> content,
    FlutterLocalNotificationsPlugin localNotificationsPlugin,
  ) {
    const androidNotificationDetails = AndroidNotificationDetails(
      'propinas-notificacao',
      'propinas-notificacao',
      importance: Importance.high,
    );

    const darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      interruptionLevel: InterruptionLevel.active,
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );

    localNotificationsPlugin.show(
      2,
      content.item1,
      content.item2,
      notificationDetails,
    );
  }
}
