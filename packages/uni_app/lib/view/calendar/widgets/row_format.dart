import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni_ui/calendar/calendar_item_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/header_info.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';

// TODO(thePeras): This class should be extracted up
class RowFormat extends StatelessWidget {
  const RowFormat({
    super.key,
    required this.event,
    required this.locale,
    this.isToday = false,
  });
  final CalendarEvent event;
  final AppLocale locale;
  final bool isToday;

  void _popUp(BuildContext context) {
    final eventPeriod = event.formattedPeriod;

    showDialog<void>(
      context: context,
      builder: (context) {
        return ModalDialog(
          children: [
            ModalHeader(name: event.name),
            ModalInfoRow(
              title: S.of(context).date,
              description: '${eventPeriod[0]} ${eventPeriod[1]}'.trim(),
              icon: UniIcons.calendar,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventperiod = event.formattedPeriod;

    return TimelineItem(
      title: eventperiod[0],
      subtitle: eventperiod[1],
      titleWidth: 90,
      isActive: isToday,
      card: CalendarItemCard(
        eventName: event.name,
        isToday: isToday,
        onTap: () => _popUp(context),
      ),
    );
  }
}
