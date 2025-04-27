import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerRestaurantPageView extends StatelessWidget {
  const ShimmerRestaurantPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 22),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GenericSquircle(
              child: Container(
                height: 250,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 22),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            // Suggestion: change the speed of shimmer
            child: GenericSquircle(
              child: Container(
                height: 250,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
