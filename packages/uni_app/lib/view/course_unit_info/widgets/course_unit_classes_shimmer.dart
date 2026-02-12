import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerCourseClasses extends StatelessWidget {
  const ShimmerCourseClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 40,
            top: 10,
            right: 20,
            left: 20,
          ),
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
              const SizedBox(width: 10),
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
              const SizedBox(width: 10),
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
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 40,
          padding: const EdgeInsets.only(right: 20, left: 20), // aqui!
          children: List.generate(
            15,
            (index) => Shimmer.fromColors(
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
      ],
    );
  }
}
