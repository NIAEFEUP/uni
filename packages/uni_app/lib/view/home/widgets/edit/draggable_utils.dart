import 'package:flutter/widgets.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni_ui/icons.dart';

(String, Icon) formatDraggableTile(FavoriteWidgetType favorite) {
  switch (favorite) {
    case FavoriteWidgetType.schedule:
      return ('Schedule', const UniIcon(UniIcons.lecture));
    case FavoriteWidgetType.exams:
      return ('Exams', const UniIcon(UniIcons.exam));
    case FavoriteWidgetType.library:
      return ('Library', const UniIcon(UniIcons.library));
    case FavoriteWidgetType.restaurants:
<<<<<<< Updated upstream
      return ('Restaurants', const UniIcon(UniIcons.restaurant));
    // case 'calendar':
    //   title = 'Calendar';
    //   icon = const UniIcon(UniIcons.calendar);
=======
      return (S.of(context).restaurants, const UniIcon(UniIcons.restaurant));
    case FavoriteWidgetType.calendar:
      return (S.of(context).calendar, const UniIcon(UniIcons.calendar));
>>>>>>> Stashed changes
    // case 'ucs':
    //   title = 'UCS';
    //   icon = const UniIcon(UniIcons.graduationCap);
    // default:
    //   title = '';
    //   icon = const UniIcon(UniIcons.graduationCap);
  }
}
