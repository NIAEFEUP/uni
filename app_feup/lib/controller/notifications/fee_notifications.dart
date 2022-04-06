import 'package:logger/logger.dart';
import 'package:uni/controller/notifications/local_notifications.dart';

class FeeNotifications {
  FeeNotifications(String feesLimit) {
    DateTime limit_date = DateTime.parse(feesLimit);
    if (limit_date.isBefore(DateTime.now())) {
      LocalNotifications.pushNotification(
        title: "Tuition Payments",
        body: "Oh no! You forgot to pay this month's tuition.",
        payload: "overdue-payment",
      );
      Logger().i("Tuition payments overdue. Notified user.");
    } else {
      Logger().i("Tuition payments in order.");
    }
  }
}
