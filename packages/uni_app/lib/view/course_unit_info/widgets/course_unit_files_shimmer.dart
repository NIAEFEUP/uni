import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerCourseFiles extends StatelessWidget {
  const ShimmerCourseFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Container(
              height: 80,
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
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Container(
              height: 80,
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
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Container(
              height: 80,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: GenericSquircle(
                  child: Container(height: 35, color: Colors.grey),
                ),
              ),
            ),
          ),
      ]
    );
  }
}
