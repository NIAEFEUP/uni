import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/view/restaurant/widgets/day_of_week_tab.dart';

import '../../locale_notifier.dart';

class DaysOfWeekTabBar extends StatelessWidget {
  const DaysOfWeekTabBar({
    super.key,
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
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      tabAlignment: TabAlignment.center,
      tabs: createTabs(context),
      dividerHeight: 0,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  List<DayOfWeekTab> createTabs(BuildContext context) {
    final weekDay = DateTime.now().weekday;
    final today = DateTime.now();

    final daysOfTheWeek =
        Provider.of<LocaleNotifier>(context).getWeekdaysWithLocale();

    final dates = List.generate(daysOfTheWeek.length, (i) {
      return today.subtract(Duration(days: weekDay - 1)).add(Duration(days: i));
    });

    final tabs = <DayOfWeekTab>[];
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(
        DayOfWeekTab(
          key: Key('cantine-page-tab-${daysOfTheWeek[i]}'),
          controller: controller,
          isSelected: controller.index == i,
          weekDay: toShortVersion(daysOfTheWeek[i]),
          day: '${dates[i].day}',
        ),
      );
    }

    return tabs;
  }

  String toShortVersion(String dayOfTheWeek) {
    final match = RegExp(r'^\p{L}+', unicode: true).firstMatch(dayOfTheWeek);
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
