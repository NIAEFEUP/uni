import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/controller/fetchers/finances/current_account_fetcher.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/duration_string_formatter.dart';

class TuitionNotification extends Notification {
  TuitionNotification();

  late DateTime _dueDate;

  @override
  String get uniqueID => 'tuition-notification';

  @override
  String get prefsToggleKey => 'tuition_notification_toogle';

  @override
  bool get defaultEnabled => true;

  @override
  NotificationChannel get channel => const NotificationChannel(
    androidId: 'propinas-notificacao',
    androidName: 'propinas-notificacao',
  );

  @override
  NotificationIdStrategy get idStrategy => const FixedNotificationId(2);

  @override
  NotificationTrigger get trigger =>
      PollTrigger(throttle: const Duration(hours: 12), shouldFire: _shouldFire);

  Future<bool> _shouldFire(Session session, DateTime now) async {
    final notificationsAreDisabled =
        !PreferencesController.getTuitionNotificationToggle();
    if (notificationsAreDisabled) {
      return false;
    }
    final feesFetcher = CurrentAccountFetcher();
    DateTime? dueDate;
    try {
      dueDate = parseFeesNextLimit(
        await feesFetcher.getUserFeesResponse(session),
      );
    } catch (_) {
      return false;
    }

    if (dueDate == null) {
      return false;
    }

    _dueDate = dueDate;
    return now.difference(_dueDate).inDays >= -3;
  }

  @override
  Future<(String, String)> buildContent(Session session) async {
    // We must add one day because the time limit is actually at 23:59 and
    // not at 00:00 of the same day
    if (_dueDate.add(const Duration(days: 1)).isBefore(DateTime.now())) {
      final duration = DateTime.now().difference(_dueDate);
      if (duration.inDays == 0) {
        return const (
          '⚠️ Ainda não pagaste as propinas ⚠️',
          'O prazo para pagar as propinas acabou ontem',
        );
      }
      return (
        '⚠️ Ainda não pagaste as propinas ⚠️',
        duration.toFormattedString(
          'Já passou {} desde a data limite',
          'Já passaram {} desde a data limite',
        ),
      );
    }
    final duration = _dueDate.difference(DateTime.now());
    if (duration.inDays == 0) {
      return const (
        'O prazo limite para as propinas está a acabar',
        'Hoje acaba o prazo para pagamento das propinas!',
      );
    }
    return (
      'O prazo limite para as propinas está a acabar',
      duration.toFormattedString(
        'Falta {} para a data limite',
        'Faltam {} para a data limite',
      ),
    );
  }
}
