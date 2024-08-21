import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    required this.tabs,
    required this.content,
    super.key,
  });

  final List<Widget> tabs;
  final List<Widget> content;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  int _currentIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions
            .where((ItemPosition position) => position.itemLeadingEdge >= 0)
            .reduce((ItemPosition current, ItemPosition next) =>
                current.itemLeadingEdge < next.itemLeadingEdge ? current : next)
            .index;

        setState(() {
          _currentIndex = firstVisibleIndex;
        });
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.tabs.asMap().entries.map((entry) {
              int index = entry.key;
              Widget tab = entry.value;
              return GestureDetector(
                onTap: () => _onTabTapped(index),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      color: _currentIndex == index
                          ? Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.25)
                          : Colors.transparent,
                      child: tab,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            itemCount: widget.content.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemBuilder: (context, index) {
              return widget.content[index];
            },
          ),
        ),
      ],
    );
  }
}
