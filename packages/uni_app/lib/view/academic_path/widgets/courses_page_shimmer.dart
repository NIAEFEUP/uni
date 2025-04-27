import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerCoursesPage extends StatelessWidget {
  const ShimmerCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
          child: Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GenericSquircle(
              child: Container(
                height: 50,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GenericSquircle(
                    child: Container(
                      height: 46,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GenericSquircle(
                        child: Container(
                          height: 70,
                          width: 180,
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GenericSquircle(
                          child: Container(
                            height: 70,
                            width: 180,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
