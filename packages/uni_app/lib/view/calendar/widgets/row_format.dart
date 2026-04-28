import 'package:flutter/material.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
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
              title: 'Date',
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
      card: GestureDetector(
        onTap: () => _popUp(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: ShapeDecoration(
            gradient: isToday
                ? RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.onTertiary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    center: Alignment.topLeft,
                    radius: 2,
                    stops: const [0, 1],
                  )
                : null,
            color: isToday ? null : Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
                blurRadius: 2,
              ),
            ],
          ),
          child: Text(
            event.name,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isToday
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
