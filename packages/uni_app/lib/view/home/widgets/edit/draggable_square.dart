import 'package:flutter/material.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/home/widgets/edit/draggable_element.dart';
import 'package:uni/view/home/widgets/edit/draggable_utils.dart';

class DraggableSquare extends StatelessWidget {
  const DraggableSquare({super.key, required this.data, this.callback});

  final FavoriteWidgetType data;
  final void Function(FavoriteWidgetType widgetType)? callback;

  void activeCallback() {
    final callback = this.callback;
    if (callback != null) {
      callback(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableElement(
      callback: activeCallback,
      data: data,
      feedbackSize: const Offset(75, 75),
      feedbackBuilder: (context, data) {
        final (title, icon) = formatDraggableTile(context, data);
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          width: 75,
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 5),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      },
      childBuilder: (context, data) {
        final (title, icon) = formatDraggableTile(context, data);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          width: 75,
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 5),
              Text(title, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        );
      },
    );
  }
}
