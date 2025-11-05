import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final eventperiod = event.formattedPeriod;

    return TimelineItem(
      title: eventperiod[0],
      subtitle: eventperiod[1],
      titleWidth: 90,
      isActive: isToday,
      card: Text(
        event.name,
        style:
            isToday
                ? Theme.of(context).headlineMedium
                : Theme.of(context).headlineSmall,
        maxLines: 5,
      ),
    );
  }
}
