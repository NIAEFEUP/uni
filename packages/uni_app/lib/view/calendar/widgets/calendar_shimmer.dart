import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCalendarItem extends StatelessWidget {
  const ShimmerCalendarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
        highlightColor:Theme.of(context).disabledColor,
        child: Container(
          height: 150,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
