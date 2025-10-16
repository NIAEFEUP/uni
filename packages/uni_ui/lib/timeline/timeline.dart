import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    required this.tabs,
    required this.content,
    required this.initialTab,
    required this.tabEnabled,
    super.key,
  });

  final List<Widget> tabs;
  final List<Widget> content;
  final int initialTab;
  final List<bool> tabEnabled;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late int _currentIndex;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController _tabScrollController = ScrollController();
  final List<GlobalKey> _tabKeys = [];
  final GlobalKey _tabsRowKey = GlobalKey();
  final GlobalKey _tabsViewportKey = GlobalKey();
  bool _didInitialScroll = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;

    _tabKeys.addAll(List.generate(widget.tabs.length, (index) => GlobalKey()));

    _itemPositionsListener.itemPositions.addListener(() {
      if (!_didInitialScroll) return;

      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisibleIndex =
            positions
                .where((ItemPosition position) => position.itemLeadingEdge >= 0)
                .reduce(
                  (ItemPosition current, ItemPosition next) =>
                      current.itemLeadingEdge < next.itemLeadingEdge
                          ? current
                          : next,
                )
                .index;

        if (_currentIndex != firstVisibleIndex) {
          setState(() {
            _currentIndex = firstVisibleIndex;
          });

          _scrollToCenterTab(firstVisibleIndex);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _itemScrollController.scrollTo(
          index: _currentIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut,
        );
      } catch (_) {}

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToCenterTab(_currentIndex);
        });
      }

      _didInitialScroll = true;
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (!widget.tabEnabled[index]) return;
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToCenterTab(index);
  }

  void _scrollToCenterTab(int index) {
    if (index < 0 || index >= _tabKeys.length) return;
    final ctx = _tabKeys[index].currentContext;
    if (ctx == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToCenterTab(index);
      });
      return;
    }

    final RenderBox? viewportBox =
        _tabsViewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToCenterTab(index);
      });
      return;
    }
    final double viewportWidth = viewportBox.size.width;
    final RenderBox tabBox = ctx.findRenderObject() as RenderBox;

    final rowCtx = _tabsRowKey.currentContext;
    if (rowCtx == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToCenterTab(index);
      });
      return;
    }

    final RenderBox rowBox = rowCtx.findRenderObject() as RenderBox;

    final tabGlobal = tabBox.localToGlobal(Offset.zero);
    final tabLocalInRow = rowBox.globalToLocal(tabGlobal);

    final tabWidth = tabBox.size.width;

    final desiredScrollWithinRow =
        tabLocalInRow.dx + (tabWidth / 2) - (viewportWidth / 2);

    final offset = desiredScrollWithinRow.clamp(
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
        SizedBox(
          height: 80,
          child: Stack(
            children: [
              SingleChildScrollView(
                key: _tabsViewportKey,
                scrollDirection: Axis.horizontal,
                controller: _tabScrollController,
                child: Row(
                  key: _tabsRowKey,
                  children:
                      widget.tabs.asMap().entries.map((entry) {
                        int index = entry.key;
                        Widget tab = entry.value;
                        bool isSelected = _currentIndex == index;
                        TextStyle textStyle =
                            Theme.of(context).textTheme.bodySmall!;
                        return GestureDetector(
                          onTap: () => _onTabTapped(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 5.0,
                            ),
                            child: GenericSquircle(
                              borderRadius: 10,
                              child: Container(
                                key: _tabKeys[index],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 9.0,
                                  horizontal: 8.0,
                                ),
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.tertiary
                                            .withValues(alpha: 0.25)
                                        : Colors.transparent,
                                child: DefaultTextStyle(
                                  style: textStyle.copyWith(
                                    color:
                                        widget.tabEnabled[index]
                                            ? (isSelected
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : Colors.black)
                                            : Colors.grey,
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
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 32,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(
                            context,
                          ).scaffoldBackgroundColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 32,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(
                            context,
                          ).scaffoldBackgroundColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: widget.content.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            initialScrollIndex: _currentIndex,
            itemBuilder: (context, index) {
              return widget.content[index];
            },
          ),
        ),
      ],
    );
  }
}
