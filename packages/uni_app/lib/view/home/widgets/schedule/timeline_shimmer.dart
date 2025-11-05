import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';
import 'package:uni_ui/theme.dart';

class ShimmerTimelineItem extends StatelessWidget {
  const ShimmerTimelineItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).grayMiddle,
      highlightColor: Theme.of(context).grayLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(width: 40, height: 16, color: white),
                const SizedBox(height: 4),
                Container(width: 30, height: 12, color: white),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                height: 60,
                width: 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: white,
                ),
              ),
            ],
          ),
          Expanded(
            child: GenericSquircle(
              borderRadius: 10,
              child: Container(
                height: 70,
                width: double.infinity,
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCardTimeline extends StatelessWidget {
  const ShimmerCardTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) => const ShimmerTimelineItem(),
    );
  }
}
