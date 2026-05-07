import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CurrentAccountShimmers extends StatelessWidget {
  const CurrentAccountShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 70,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 70,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRSuperellipse(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                highlightColor: Theme.of(context).disabledColor,
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
