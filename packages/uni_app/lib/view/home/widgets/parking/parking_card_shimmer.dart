import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerParkingHomeCard extends StatelessWidget {
  const ShimmerParkingHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GenericSquircle(
        child: Container(
          height: 160,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
