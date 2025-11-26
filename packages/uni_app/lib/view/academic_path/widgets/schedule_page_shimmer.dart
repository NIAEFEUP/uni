import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/common/generic_squircle.dart';

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
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
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
                height: 30,
                width: 200,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
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
        ).expand((element) => element),
      ],
    );
  }
}
