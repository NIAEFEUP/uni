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
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16,
          ),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.25,
              child: AspectRatio(
                aspectRatio: 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GenericSquircle(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(height: 50, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GenericSquircle(
                          child: Container(height: 46, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 5,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GenericSquircle(
                          child: Container(height: 46, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: GenericSquircle(
                            child: Container(
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: GenericSquircle(
                            child: Container(
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
