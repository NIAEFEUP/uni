import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/model/providers/riverpod/schedule_view_mode_provider.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerSchedulePage extends ConsumerWidget {
  const ShimmerSchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScheduleViewMode selectedView = ref.watch<ScheduleViewMode>(
      scheduleViewModeProvider,
    );

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildTopDaysRow(context),
        if (selectedView == ScheduleViewMode.list)
          ..._buildListShimmer(context)
        else
          ..._buildCalendarShimmer(context),
      ],
    );
  }

  Widget _buildTopDaysRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ...List.generate(
              14,
              (index) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                  top: 4,
                  left: 6,
                  right: 6,
                ),
                child: SizedBox(
                  width: 50,
                  height: 55,
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                    highlightColor: Theme.of(context).disabledColor,
                    child: GenericSquircle(
                      borderRadius: 10,
                      child: Container(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListShimmer(BuildContext context) {
    return List.generate(
      3,
      (index) => [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 16,
            top: 16,
            right: 150,
          ),
          child: SizedBox(
            height: 30,
            width: 200,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: Container(height: 20, width: 200, color: Colors.grey),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ShimmerTimelineItem(),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ShimmerTimelineItem(),
        ),
      ],
    ).expand((element) => element).toList();
  }

  List<Widget> _buildCalendarShimmer(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Column(
          children: List.generate(
            12,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 10,
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(
                        context,
                      ).disabledColor.withAlpha(0x7f),
                      highlightColor: Theme.of(context).disabledColor,
                      child: Container(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(
                        context,
                      ).disabledColor.withAlpha(0x7f),
                      highlightColor: Theme.of(context).disabledColor,
                      child: Container(height: 1, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
