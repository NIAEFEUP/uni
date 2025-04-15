import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerRestaurantsHomeCard extends StatelessWidget {
  const ShimmerRestaurantsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GenericSquircle(
        child: Container(
          height: 150,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
