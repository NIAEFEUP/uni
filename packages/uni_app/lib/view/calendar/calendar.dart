import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/row_format.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class CalendarPageView extends ConsumerStatefulWidget {
  const CalendarPageView({super.key});

  @override
  ConsumerState<CalendarPageView> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends SecondaryPageViewState<CalendarPageView> {
  final GlobalKey _targetEventKey = GlobalKey();

  @override
  Widget getBody(BuildContext context) {
    return DefaultConsumer<LocalizedEvents>(
      provider: calendarProvider,
      hasContent: (localizedEvents) => localizedEvents.hasAnyEvents,
      nullContentWidget: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      builder: (context, ref, localizedEvents) {
        final locale = ref.watch(localeProvider.select((value) => value));
        final calendar = localizedEvents.getEvents(locale);
        final today = DateTime.now();

        final targetIndex = calendar.indexWhere((event) {
          final end = event.endDate ?? event.startDate;
          return end == null || !end.isBefore(today);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_targetEventKey.currentContext != null) {
            Scrollable.ensureVisible(
              _targetEventKey.currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: calendar.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                final start = event.startDate;
                final end = event.endDate ?? event.startDate;
                final isToday =
                    start != null &&
                        today.year == start.year &&
                        today.month == start.month &&
                        today.day == start.day ||
                    (end != null &&
                        today.isAfter(start ?? end) &&
                        today.isBefore(end.add(const Duration(days: 1))));
                return RowFormat(
                  key: index == targetIndex ? _targetEventKey : null,
                  event: event,
                  locale: locale,
                  isToday: isToday,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    await ref.read(calendarProvider.notifier).refreshRemote();
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navCalendar.route);
}
