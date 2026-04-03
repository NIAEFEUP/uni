import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni_ui/icons.dart';

(String, Icon) formatDraggableTile(
  BuildContext context,
  FavoriteWidgetType favorite,
) {
  switch (favorite) {
    case FavoriteWidgetType.schedule:
      return (S.of(context).schedule, UniIcon(UniIcons.lecture, color: Theme.of(context).iconTheme.color));
    case FavoriteWidgetType.exams:
      return (S.of(context).exams, UniIcon(UniIcons.exam, color: Theme.of(context).iconTheme.color));
    case FavoriteWidgetType.library:
      return (S.of(context).library, UniIcon(UniIcons.library, color: Theme.of(context).iconTheme.color));
    case FavoriteWidgetType.restaurants:
      return (S.of(context).restaurants, UniIcon(UniIcons.restaurant, color: Theme.of(context).iconTheme.color));
    case FavoriteWidgetType.calendar:
      return (S.of(context).calendar, UniIcon(UniIcons.calendar, color: Theme.of(context).iconTheme.color));
    case FavoriteWidgetType.news:
      return (S.of(context).news, UniIcon(UniIcons.news, color: Theme.of(context).iconTheme.color));
    // case 'ucs':
    //   title = 'UCS';
    //   icon = const UniIcon(UniIcons.graduationCap);
    // default:
    //   title = '';
    //   icon = const UniIcon(UniIcons.graduationCap);
  }
}
