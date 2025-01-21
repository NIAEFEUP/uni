import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/restaurant/widgets/day_of_week_tab.dart';

import '../../locale_notifier.dart';

class DaysOfWeekTabBar extends StatelessWidget {

  const DaysOfWeekTabBar({super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      padding: EdgeInsets.zero,
      indicator: const BoxDecoration(),
      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
      tabAlignment: TabAlignment.center,
      tabs: createTabs(context),
      dividerHeight: 0,
    );
  }


  List<DayOfWeekTab> createTabs(BuildContext context) {
    final weekDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
    final daysOfTheWeek =
    Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();
    final today = DateTime.now();

    // Reorder the daysOfTheWeek list
    List<String> reorderedDays;
    if (weekDay == 1) {
      reorderedDays = [
        daysOfTheWeek[(weekDay - 2 + 7) % 7], // Previous day
        ...daysOfTheWeek.skip(weekDay - 1).take(6), // From today onwards
      ];
    } else {
      reorderedDays = [
        daysOfTheWeek[(weekDay - 2 + 7) % 7], // Previous day
        ...daysOfTheWeek.skip(weekDay - 1), // From today onwards
        ...daysOfTheWeek.take(weekDay - 2) // Remaining days from the start
      ];
    }

    // Calculate the dates for the reordered days
    final reorderedDates = [
      today.subtract(const Duration(days: 1)), // Previous day
      ...List.generate(7, (i) => today.add(Duration(days: i)))
          .skip(0), // From today onwards
    ].take(7).toList();

    final tabs = <DayOfWeekTab>[];
    for (var i = 0; i < reorderedDays.length; i++) {
      tabs.add(
        DayOfWeekTab(
          key: Key('cantine-page-tab-$i'),
          controller: controller,
          isSelected: controller.index == i,
          weekDay: toShortVersion(reorderedDays[i]),
          day: '${reorderedDates[i].day}',
        )
      );
    }
    return tabs;
  }

  String toShortVersion(String dayOfTheWeek) {
    final match = RegExp('^[a-zA-Z]+').firstMatch(dayOfTheWeek);
    if (match != null) {
      final matchedString = match.group(0)!;
      final shortened = matchedString.length >= 3
          ? matchedString.substring(0, 3)
          : matchedString;
      return shortened[0].toUpperCase() + shortened.substring(1).toLowerCase();
    }
    return 'Blank';
  }

}