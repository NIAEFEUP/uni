import 'package:flutter/material.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class CalendarLine extends StatelessWidget {
  const CalendarLine({super.key, required this.calendarItemsCount});

  final int calendarItemsCount;

  @override
  Widget build(BuildContext context) {
    if (calendarItemsCount == 0) return Container();

    return Container(
      margin: const EdgeInsets.only(top: 44),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 4,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
          ),
          ...List.filled(
            calendarItemsCount - 1,
            Container(
              width: 120,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            width: 80,
            height: 4,
            margin: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                bottomLeft: Radius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.items, this.initialScrollIndex = 0});

  final List<CalendarItem> items;
  final int initialScrollIndex;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialScrollIndex > 0 &&
          widget.initialScrollIndex < widget.items.length) {
        final offset = widget.initialScrollIndex * 150.0;
        _scrollController.jumpTo(offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items,
            ),
          ),
          CalendarLine(calendarItemsCount: widget.items.length),
        ],
      ),
    );
  }
}
