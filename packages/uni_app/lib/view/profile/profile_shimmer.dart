import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({super.key, this.name});
  final String? name;
  @override
  Widget build(BuildContext context) {
    double width = (name?.length ?? 10) * 15.0;
    width = width.clamp(80.0, 200.0);
    return Shimmer.fromColors(
      baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
      highlightColor: Theme.of(context).disabledColor,
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: width,
            height: 20,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Container(
            width: 85,
            height: 12,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 45,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
