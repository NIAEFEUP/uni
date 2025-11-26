import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni_ui/cards/generic_card.dart';

class ShimmerSchedulePage extends StatelessWidget {
  const ShimmerSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                14,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: SizedBox(
                    width: 60,
                    height: 65,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const GenericCard(borderRadius: 10, tooltip: ' '),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ...List.generate(
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
                height: 40,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const GenericCard(tooltip: ' ', borderRadius: 0),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: ShimmerTimelineItem(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: ShimmerTimelineItem(),
            ),
          ],
        ).expand((element) => element),
      ],
    );
  }
}
