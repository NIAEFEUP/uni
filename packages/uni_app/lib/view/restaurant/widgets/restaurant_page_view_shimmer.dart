import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerRestaurantPageView extends StatelessWidget {
  const ShimmerRestaurantPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GenericSquircle(
            child: Container(
              height: 200,
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          // Suggestion: change the speed of shimmer
          child: GenericSquircle(
            child: Container(
              height: 200,
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          // Suggestion: change the speed of shimmer
          child: GenericSquircle(
            child: Container(
              height: 200,
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
