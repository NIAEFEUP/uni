import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uni_ui/common/generic_squircle.dart';

typedef TimelineContentBuilder = Widget Function(BuildContext context, int index);

class Timeline extends StatefulWidget {
  const Timeline({
    required this.tabs,
    required this.content,
    required this.initialTab,
    required this.tabEnabled,
    this.contentBuilder,
    super.key,
  });

  final List<Widget> tabs;
  final List<Widget>? content;
  final TimelineContentBuilder? contentBuilder;
  final int initialTab;
  final List<bool> tabEnabled;

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late final ValueNotifier<int> _currentIndexNotifier;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController _tabScrollController = ScrollController();
  final List<GlobalKey> _tabKeys = [];
  final GlobalKey _tabsViewportKey = GlobalKey();
  bool _didInitialScroll = false;
  bool _isManualScrolling = false;

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier<int>(widget.initialTab);

    _tabKeys.addAll(List.generate(widget.tabs.length, (index) => GlobalKey()));

    _itemPositionsListener.itemPositions.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await _itemScrollController.scrollTo(
          index: _currentIndexNotifier.value,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut,
        );
      } catch (_) {}

      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _scrollToCenterTab(_currentIndexNotifier.value);
      });
      _didInitialScroll = true;
    });
  }

  void _onScroll() {
    if (!_didInitialScroll || _isManualScrolling) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final visiblePositions = positions.where(
      (ItemPosition position) => position.itemLeadingEdge >= -0.1,
    );
    
    if (visiblePositions.isNotEmpty) {
      final firstVisibleIndex = visiblePositions
          .reduce(
            (ItemPosition current, ItemPosition next) =>
                current.itemLeadingEdge < next.itemLeadingEdge ? current : next,
          )
          .index;

      if (_currentIndexNotifier.value != firstVisibleIndex) {
        _currentIndexNotifier.value = firstVisibleIndex;
        _scrollToCenterTab(firstVisibleIndex);
      }
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    _currentIndexNotifier.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  Future<void> _onTabTapped(int index) async {
    if (!widget.tabEnabled[index] || _currentIndexNotifier.value == index) {
      return;
    }
    
    _isManualScrolling = true;
    _currentIndexNotifier.value = index;
    _scrollToCenterTab(index);

    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    _isManualScrolling = false;
  }

  void _scrollToCenterTab(int index) {
    if (!mounted || index < 0 || index >= _tabKeys.length) return;
    
    final tabCtx = _tabKeys[index].currentContext;
    final viewportCtx = _tabsViewportKey.currentContext;

    if (tabCtx == null || viewportCtx == null) return;

    final RenderBox tabBox = tabCtx.findRenderObject() as RenderBox;
    final RenderBox viewportBox = viewportCtx.findRenderObject() as RenderBox;

    final tabGlobalPos = tabBox.localToGlobal(Offset.zero);
    final viewportGlobalPos = viewportBox.localToGlobal(Offset.zero);

    final tabRelativePos = tabGlobalPos.dx - viewportGlobalPos.dx;
    final tabWidth = tabBox.size.width;
    final viewportWidth = viewportBox.size.width;

    if (_tabScrollController.hasClients) {
      final currentOffset = _tabScrollController.offset;
      final targetOffset = (currentOffset + (tabRelativePos + tabWidth / 2) - (viewportWidth / 2)).clamp(
        0.0,
        _tabScrollController.position.maxScrollExtent,
      );

      _tabScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: SizedBox(
            height: 70,
            child: Stack(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _currentIndexNotifier,
                  builder: (context, currentIndex, _) {
                    return SingleChildScrollView(
                      key: _tabsViewportKey,
                      scrollDirection: Axis.horizontal,
                      controller: _tabScrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: List.generate(widget.tabs.length, (index) {
                          final isSelected = currentIndex == index;
                          final textStyle = Theme.of(context).textTheme.bodySmall!;
                          
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
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withValues(alpha: 0.25)
                                      : Colors.transparent,
                                  child: DefaultTextStyle(
                                    style: textStyle.copyWith(
                                      color: widget.tabEnabled[index]
                                          ? (isSelected
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.black)
                                          : Colors.grey,
                                    ),
                                    child: widget.tabs[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                _buildGradients(context),
              ],
            ),
          ),
        ),
        Expanded(
          child: RepaintBoundary(
            child: ScrollablePositionedList.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: widget.tabs.length,
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              initialScrollIndex: widget.initialTab,
              itemBuilder: (context, index) {
                if (widget.contentBuilder != null) {
                  return widget.contentBuilder!(context, index);
                }
                return widget.content![index];
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradients(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 32,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [bgColor, bgColor.withAlpha(0)],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 32,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [bgColor, bgColor.withAlpha(0)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
