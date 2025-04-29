import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni_ui/icons.dart';

(String, Icon) formatDraggableTile(
  BuildContext context,
  FavoriteWidgetType favorite,
) {
  switch (favorite) {
    case FavoriteWidgetType.schedule:
      return (S.of(context).schedule, const UniIcon(UniIcons.lecture));
    case FavoriteWidgetType.exams:
      return (S.of(context).exams, const UniIcon(UniIcons.exam));
    case FavoriteWidgetType.library:
      return (S.of(context).library, const UniIcon(UniIcons.library));
    case FavoriteWidgetType.restaurants:
      return (S.of(context).restaurants, const UniIcon(UniIcons.restaurant));
    // case 'calendar':
    //   title = 'Calendar';
    //   icon = const UniIcon(UniIcons.calendar);
    // case 'ucs':
    //   title = 'UCS';
    //   icon = const UniIcon(UniIcons.graduationCap);
    // default:
    //   title = '';
    //   icon = const UniIcon(UniIcons.graduationCap);
  }
}
