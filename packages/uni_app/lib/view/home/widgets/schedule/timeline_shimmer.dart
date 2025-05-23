import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerTimelineItem extends StatelessWidget {
  const ShimmerTimelineItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(width: 40, height: 16, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 30, height: 12, color: Colors.white),
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
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                height: 60,
                width: 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
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
                color: Colors.white,
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
