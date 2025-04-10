import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/model/utils/time/weekday_mapper.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';
import 'package:uni_ui/modal/modal.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends SecondaryPageViewState<SchedulePage> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => SchedulePageView(
        lectures,
        now: widget.now,
      ),
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: SchedulePageView(const [], now: widget.now),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    await context.read<LectureProvider>().forceRefresh(context);
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navSchedule.route);
}

class SchedulePageView extends StatefulWidget {
  SchedulePageView(this.lectures, {required DateTime now, super.key})
      : currentWeek = Week(start: now);

  final List<Lecture> lectures;
  final Week currentWeek;

  @override
  SchedulePageViewState createState() => SchedulePageViewState();
}

class SchedulePageViewState extends State<SchedulePageView>
    with TickerProviderStateMixin {
  TabController? tabController;
  late final List<Lecture> lecturesThisWeek;

  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  Calendar? _selectedCalendar;

  List<Calendar> get _writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 6,
    );

    var weekDay = widget.currentWeek.start.weekday;

    _deviceCalendarPlugin = DeviceCalendarPlugin();

    lecturesThisWeek = <Lecture>[];
    widget.currentWeek.weekdays.take(6).forEach((day) {
      final lectures = lecturesOfDay(widget.lectures, day);
      lecturesThisWeek.addAll(lectures);
    });

    if (lecturesThisWeek.isNotEmpty) {
      final now = DateTime.now();

      final nextLecture = lecturesThisWeek
          .where((lecture) => lecture.endTime.isAfter(now))
          .fold<Lecture?>(null, (closest, lecture) {
        if (closest == null) {
          return lecture;
        }
        return lecture.endTime.difference(now) < closest.endTime.difference(now)
            ? lecture
            : closest;
      });

      if (nextLecture != null) {
        weekDay = nextLecture.endTime.weekday;
      }
    }

    final offset = (weekDay > 6) ? 0 : (weekDay - 1) % 6;
    tabController?.animateTo(tabController!.index + offset);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await _retrieveCalendars();
                  await showCalendarModal();
                },
                child: const Text('Save lectures'),
              ),
            ],
          ),
        ),
        TabBar(
          controller: tabController,
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          tabs: createTabs(queryData, context),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: widget.currentWeek.weekdays.take(6).map((day) {
              final lectures = lecturesOfDay(lecturesThisWeek, day);
              final index = WeekdayMapper.fromDartToIndex.map(day.weekday);
              if (lectures.isEmpty) {
                return emptyDayColumn(context, index);
              } else {
                return dayColumnBuilder(index, lectures, context);
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Returns a list of widgets empty with tabs for each day of the week.
  List<Widget> createTabs(MediaQueryData queryData, BuildContext context) {
    final tabs = <Widget>[];
    final workWeekDays =
        context.read<LocaleNotifier>().getWeekdaysWithLocale().sublist(0, 6);
    workWeekDays.asMap().forEach((index, day) {
      tabs.add(
        SizedBox(
          width: (queryData.size.width * 1) / 4,
          child: Tab(
            key: Key('schedule-page-tab-$index'),
            text: day,
          ),
        ),
      );
    });
    return tabs;
  }

  Widget dayColumnBuilder(
    int day,
    List<Lecture> lectures,
    BuildContext context,
  ) {
    return Container(
      key: Key('schedule-page-day-column-$day'),
      child: ListView(
        children: lectures
            .map(
              // TODO(thePeras): ScheduleSlot should receive a lecture
              //  instead of all these parameters.
              (lecture) => ScheduleSlot(
                subject: lecture.subject,
                typeClass: lecture.typeClass,
                rooms: lecture.room,
                begin: lecture.startTime,
                end: lecture.endTime,
                occurrId: lecture.occurrId,
                teacher: lecture.teacher,
                classNumber: lecture.classNumber,
              ),
            )
            .toList(),
      ),
    );
  }

  static List<Lecture> lecturesOfDay(List<Lecture> lectures, DateTime day) {
    final filteredLectures = <Lecture>[];
    for (var i = 0; i < lectures.length; i++) {
      final lecture = lectures[i];
      if (lecture.startTime.day == day.day &&
          lecture.startTime.month == day.month &&
          lecture.startTime.year == day.year) {
        filteredLectures.add(lecture);
      }
    }
    return filteredLectures;
  }

  Widget emptyDayColumn(BuildContext context, int day) {
    final weekday =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale()[day];

    final noClassesText = day >= DateTime.saturday - 1
        ? S.of(context).no_classes_on_weekend
        : S.of(context).no_classes_on;

    return Center(
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: '$noClassesText $weekday.',
        labelTextStyle: const TextStyle(fontSize: 15),
      ),
    );
  }

  Future<void> _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      try {
        setState(() {
          _calendars = List<Calendar>.from(calendarsResult.data ?? []);
        });
      } catch (err, st) {
        debugPrint('Error inside setState: $err');
        debugPrint('Stack trace:\n$st');
      }
    } on PlatformException catch (e, st) {
      debugPrint('RETRIEVE_CALENDARS: $e, $st');
    }
  }

  Future<void> addLecturesToCalendar(
    Calendar selectedCalendar,
    List<Lecture> lectures,
  ) async {
    final now = DateTime.now();
    lectures
        .where((lecture) => lecture.endTime.isAfter(now))
        .forEach((lecture) {
      final event = Event(
        selectedCalendar.id,
        title: '${lecture.subject} (${lecture.typeClass})',
        location: lecture.room,
        start: tz.TZDateTime.from(lecture.startTime, tz.local),
        end: tz.TZDateTime.from(lecture.endTime, tz.local),
      );

      _deviceCalendarPlugin.createOrUpdateEvent(event);
    });
  }

  Future<void> showCalendarModal() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ModalDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Select Calendar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                if (_writableCalendars.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Align(
                      child: Text(
                        'No calendars available',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _writableCalendars.length,
                      itemBuilder: (context, index) {
                        final calendar = _writableCalendars[index];
                        return ListTile(
                          title: Text(calendar.name ?? 'Unnamed Calendar'),
                          selected: _selectedCalendar?.id == calendar.id,
                          selectedTileColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          tileColor: Theme.of(context).colorScheme.surface,
                          onTap: () {
                            setModalState(() {
                              _selectedCalendar = calendar;
                            });
                          },
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _selectedCalendar == null
                        ? null
                        : () async {
                            if (_writableCalendars.isNotEmpty) {
                              await addLecturesToCalendar(
                                _selectedCalendar!,
                                widget.lectures,
                              );
                            }
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    child: const Text('Add to calendar'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
