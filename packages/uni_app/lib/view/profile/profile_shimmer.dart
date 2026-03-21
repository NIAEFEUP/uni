import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';
class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
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
          const SizedBox(height: 20),
          Container(
            width: 145,
            height: 21,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 90,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 13),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenericSquircle(
                borderRadius: 20,
                child: SizedBox(
                  width: 75,
                  height: 58,
                  child: Container(color: Colors.white),
                ),
              ),
              const SizedBox(width: 7),
              GenericSquircle(
                borderRadius: 20,
                child: SizedBox(
                  width: 100,
                  height: 58,
                  child: Container(color: Colors.white),
                ),
              ),
              const SizedBox(width: 7),
              GenericSquircle(
                borderRadius: 20,
                child: SizedBox(
                  width: 143,
                  height: 58,
                  child: Container(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
