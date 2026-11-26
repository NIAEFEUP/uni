import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:workmanager/workmanager.dart';

/// This map contains the functions that a certain task type will run.
/// the bool is all functions that are ran by backgroundfetch in iOS
/// (they must not take any arguments, not checked)
const taskMap = {
  'pt.up.fe.ni.uni.notificationworker': (
    NotificationManager.updateAndTriggerNotifications,
    true,
  ),
};

@pragma('vm:entry-point')
// This function is android only and only executes
// when the app is completely terminated
Future<void> workerStartCallback() async {
  Workmanager().executeTask((taskName, inputData) async {
    final transaction = Sentry.startTransaction(taskName, 'background_worker');
    try {
      Logger().d('''[$taskName]: Start executing job...''');

      // iOSBackgroundTask is a special task, that iOS runs whenever
      // it deems necessary and will run all tasks with the flag true
      // NOTE: keep the total execution time under 30s to avoid being punished
      // by the iOS scheduler.
      if (taskName == Workmanager.iOSBackgroundTask) {
        taskMap.forEach((key, value) async {
          if (value.$2) {
            Logger().d('''[$key]: Start executing job...''');
            await value.$1();
          }
        });
        transaction.status = const SpanStatus.ok();
        return true;
      }
      // try to keep the usage of this function BELOW +-30 seconds
      // to not be punished by the scheduler in future runs.
      await taskMap[taskName]!.$1();
      transaction.status = const SpanStatus.ok();
    } catch (err, st) {
      transaction.status = const SpanStatus.internalError();
      await Sentry.captureException(err, stackTrace: st);
      Logger().e(
        'Error while running $taskName job:',
        error: err,
        stackTrace: st,
      );
      return false;
    } finally {
      await transaction.finish();
    }
    return true;
  });
}
