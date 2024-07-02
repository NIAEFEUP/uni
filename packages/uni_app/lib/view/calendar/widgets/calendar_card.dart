import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/calendar.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';

class CalendarCard extends GenericCard {
  CalendarCard({super.key});

  const CalendarCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(NavigationItem.navCalendar.route);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navCalendar.route}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<CalendarProvider>(context, listen: false).forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<CalendarProvider, List<CalendarEvent>>(
      builder: (context, events) => CalendarPageViewState()
          .getTimeline(context, getFurtherEvents(events)),
      hasContent: (calendar) => calendar.isNotEmpty,
      onNullContent: Center(
        child: Text(
          S.of(context).no_events,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  List<CalendarEvent> getFurtherEvents(List<CalendarEvent> events) {
    final sortedEvents = events
        .where((element) => element.parsedStartDate != null)
        .sorted((a, b) => a.parsedStartDate!.compareTo(b.parsedStartDate!));
    final pinEvent = sortedEvents.firstWhere(
      (element) => element.parsedStartDate!.compareTo(DateTime.now()) == 1,
    );
    return sortedEvents.sublist(
      sortedEvents.indexOf(pinEvent),
      sortedEvents.indexOf(pinEvent) + 3,
    );
  }
}
