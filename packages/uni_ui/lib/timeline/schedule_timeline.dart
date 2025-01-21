import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScheduleTimeline extends StatefulWidget {
  const ScheduleTimeline({
    required this.tabs,
    required this.content,
    required this.initialTabIndex,
    super.key,
  });

  final List<Widget> tabs;
  final List<Widget> content;
  final int initialTabIndex;

  @override
  State<ScheduleTimeline> createState() => _ScheduleTimelineState();
}

class _ScheduleTimelineState extends State<ScheduleTimeline> {
  late int _currentIndex;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController _tabScrollController = ScrollController();
  final List<GlobalKey> _tabKeys = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;

    _tabKeys.addAll(List.generate(widget.tabs.length, (index) => GlobalKey()));

    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions
            .where((ItemPosition position) => position.itemLeadingEdge >= 0)
            .reduce((ItemPosition current, ItemPosition next) =>
                current.itemLeadingEdge < next.itemLeadingEdge ? current : next)
            .index;

        if (_currentIndex != firstVisibleIndex &&
            firstVisibleIndex >= widget.initialTabIndex) {
          setState(() {
            _currentIndex = firstVisibleIndex;
          });

          _scrollToCenterTab(firstVisibleIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToCenterTab(index);
  }

  void _scrollToCenterTab(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final RenderBox tabBox =
        _tabKeys[index].currentContext!.findRenderObject() as RenderBox;

    final tabWidth = tabBox.size.width;
    final offset = (_tabScrollController.offset +
            tabBox.localToGlobal(Offset.zero).dx +
            (tabWidth / 2) -
            (screenWidth / 2))
        .clamp(
      0.0,
      _tabScrollController.position.maxScrollExtent,
    );

    _tabScrollController.animateTo(
      offset,
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
          controller: _tabScrollController,
          child: Row(
            children: widget.tabs.asMap().entries.map((entry) {
              int index = entry.key;
              Widget tab = entry.value;
              bool isSelected = _currentIndex == index;
              TextStyle textStyle = Theme.of(context).textTheme.bodySmall!;
              return GestureDetector(
                onTap: () => _onTabTapped(index),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 10,
                      cornerSmoothing: 1,
                    ),
                    child: Container(
                      key: _tabKeys[index],
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.25)
                          : Colors.transparent,
                      child: DefaultTextStyle(
                        style: textStyle.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                        ),
                        child: tab,
                      ),
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
