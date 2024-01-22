import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        child: LazyConsumer<CalendarProvider, List<CalendarEvent>>(
          builder: CalendarPageViewState().getTimeline,
          hasContent: (calendar) => calendar.isNotEmpty,
          onNullContent: const Center(
            child: Text(
              'Nenhum evento encontrado',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
