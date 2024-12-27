import "dart:async";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart";
import "package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart";
import "package:uni/controller/local_storage/database/app_lectures_database.dart";
import "package:uni/model/entities/lecture.dart";
import "package:uni/model/providers/state_provider_notifier.dart";
import "package:uni/model/providers/state_providers.dart";
import "package:uni/session/flows/base/session.dart";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void initializeNotifications() {
    const androidInitialization = AndroidInitializationSettings("app_icon");
    const iOSInitialization = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: androidInitialization,
        iOS: iOSInitialization,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tzData.initializeTimeZones();
}


class LectureProvider extends StateProviderNotifier<List<Lecture>> {
    LectureProvider() : super(cacheDuration: const Duration(hours: 6));


    @override
    Future<List<Lecture>> loadFromStorage(StateProviders stateProviders) async {
        final db = AppLecturesDatabase();
        return db.lectures();
    }

    @override
    Future<List<Lecture>> loadFromRemote(StateProviders stateProviders) async {
        return fetchUserLectures(
            stateProviders.sessionProvider.state!,
        );
    }

    Future<List<Lecture>> fetchUserLectures(
        Session session, {
            ScheduleFetcher? fetcher,
        }) async {
            final lectures = await getLecturesFromFetcherOrElse(fetcher, session);

            final db = AppLecturesDatabase();
            await db.saveIfPersistentSession(lectures);

            return lectures;
        }

        Future<List<Lecture>> getLecturesFromFetcherOrElse(
            ScheduleFetcher? fetcher,
            Session session,
        ) =>
            fetcher?.getLectures(session) ?? getLectures(session);

        Future<List<Lecture>> getLectures(Session session) {
            return ScheduleFetcherNewApi().getLectures(session).catchError(
                (e) => <Lecture>[],
            );
    }
}

void scheduleLectureNotifications(List<Lecture> lectures, FlutterLocalNotificationsPlugin localNotificationsPlugin) {
    for (Lecture lecture in lectures) {
        DateTime lectureStart = lecture.startTime;
        DateTime notificationTime = lectureStart.subtract(Duration(minutes: 15));

        if (notificationTime.isAfter(DateTime.now())) {
            _scheduleNotification(notificationTime, lecture, localNotificationsPlugin);
        }
    }
}


Future<void> _scheduleNotification(DateTime notificationTime, Lecture lecture, FlutterLocalNotificationsPlugin localNotificationsPlugin) async {
    final location = tz.getLocation("Europe/Lisbon");
    final zonedNotificationTime = tz.TZDateTime.from(notificationTime, location);

    const androidDetails = AndroidNotificationDetails(
        "lecture_notification_channel",
        "Lecture Notifications",
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false
    );
    const iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        interruptionLevel: InterruptionLevel.active,
    );

    const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
    );

    await localNotificationsPlugin.zonedSchedule(
        0,
        "Upcoming Lecture: ${lecture.title}",
        "Your lecture ${lecture.title} starts in 15 minutes!",
        zonedNotificationTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
}


void onLecturesFetched(List<Lecture> lectures) {
    scheduleLectureNotifications(lectures, flutterLocalNotificationsPlugin);
}
