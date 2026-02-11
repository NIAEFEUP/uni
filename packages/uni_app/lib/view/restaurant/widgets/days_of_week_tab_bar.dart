import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/tab_controller_provider.dart';
import 'package:uni/view/restaurant/widgets/day_of_week_tab.dart';

class DaysOfWeekTabBar extends ConsumerWidget {
  const DaysOfWeekTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: createTabs(context, ref)),
  );

  List<Widget> createTabs(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(tabControllerProvider);
    final tabController = ref.read(tabControllerProvider.notifier);
    final localeNotifier = ref.read(localeProvider.notifier);

    final weekDay = DateTime.now().weekday;
    final today = DateTime.now();

    final daysOfTheWeek = localeNotifier.getWeekdaysWithLocale();

    final dates = List.generate(daysOfTheWeek.length, (i) {
      return today.subtract(Duration(days: weekDay - 1)).add(Duration(days: i));
    });

    final tabs = <Widget>[];
    for (var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(
        GestureDetector(
          onTap: () => tabController.setTabIndex(i),
          child: DayOfWeekTab(
            key: Key('cantine-page-tab-${daysOfTheWeek[i]}'),
            isSelected: selectedTabIndex == i,
            weekDay: toShortVersion(daysOfTheWeek[i]),
            day: '${dates[i].day}',
          ),
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
