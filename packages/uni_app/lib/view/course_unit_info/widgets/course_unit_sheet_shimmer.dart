import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerCourseSheet extends StatelessWidget {
  const ShimmerCourseSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // instructors
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: AspectRatio(
                aspectRatio: 3,
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
        // Assessments
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: AspectRatio(
                aspectRatio: 3,
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
        // program
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: AspectRatio(
                aspectRatio: 2,
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
        // evaluation
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: AspectRatio(
                aspectRatio: 3,
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
        // Eligibility
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: AspectRatio(
                aspectRatio: 5,
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
        // bibliography
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            height: 30,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
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
      ],
    );
  }
}
