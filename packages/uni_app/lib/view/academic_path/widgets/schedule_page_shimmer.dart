import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni_ui/timeline/timeline.dart';
import '../../locale_notifier.dart';

int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear =
        (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}

class ShimmerSchedulePage extends ConsumerWidget {
  const ShimmerSchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = DateTime.now();
    final currentMonthLength = getDaysInMonth(
      currentDay.year,
      currentDay.month,
    );
    final nextMonthDay = currentDay.add(
      Duration(days: currentMonthLength - currentDay.day),
    );
    int monthAfter = nextMonthDay.month + 1;
    int yearAfter = nextMonthDay.year;

    if (monthAfter > 12) {
      monthAfter = 1;
      yearAfter += 1;
    }
    final allDays = List.generate(
      getDaysInMonth(currentDay.year, currentDay.month) +
          getDaysInMonth(yearAfter, monthAfter),
      (index) => index + 1,
    );
    final localeNotifier = ref.read(localeProvider.notifier);
    final tabs =
        allDays.map((day) {
          final date = DateTime(
            currentDay.year,
            currentDay.month,
          ).add(Duration(days: day - 1));
          return SizedBox(
            width: 30,
            height: 34,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    date.shortMonth(localeNotifier.getLocale()),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${date.day}', // Correctly displays the day of the month
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList();
    // TODO: make timeline more empty content-proof
    return Timeline(
      tabs: tabs,
      content: List.generate(12, (index) {
        final date = DateTime(
          currentDay.year,
          currentDay.month,
        ).add(Duration(days: index - 1));
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  date.formattedDate(localeNotifier.getLocale()),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                  maxLines: 1,
                ),
              ),
              const ShimmerTimelineItem(),
              const ShimmerTimelineItem(),
            ],
          ),
        );
      }),
      initialTab: currentDay.day,
      tabEnabled: List.generate(allDays.length, (index) {
        final today = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
        );
        final tabDate = DateTime(
          currentDay.year,
          currentDay.month,
        ).add(Duration(days: index));
        return !tabDate.isBefore(today);
      }),
    );
  }
}
