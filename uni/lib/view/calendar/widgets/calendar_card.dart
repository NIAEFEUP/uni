import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/calendar/calendar.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';

class ScrollableCalendarCard extends GenericCard {
  ScrollableCalendarCard({super.key});

  const ScrollableCalendarCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(DrawerItem.navCalendar.title);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navCalendar.title}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<CalendarProvider>(context, listen: false).forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Expanded(
      child: LazyConsumer<CalendarProvider, List<CalendarEvent>>(
        builder: (context, events) => CalendarPageViewState()
            .getTimeline(context, getFurtherEvents(events)),
        hasContent: (calendar) => calendar.isNotEmpty,
        onNullContent: const Center(
          child: Text(
            'Nenhum evento encontrado',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  List<CalendarEvent> getFurtherEvents(List<CalendarEvent> events) {
    final currentMonth = DateFormat.MMMM('pt').format(DateTime.now());
    final pinEvent = events.firstWhere((element) {
      final eventDate = element.date.split(' ');
      final month = eventDate.where((element) =>
          DateFormat.MMMM('pt').dateSymbols.MONTHS.contains(element) ||
          element == 'TBD');
      return month.contains(currentMonth);
    });

    return events.sublist(
        events.indexOf(pinEvent), events.indexOf(pinEvent) + 3);
  }
}
