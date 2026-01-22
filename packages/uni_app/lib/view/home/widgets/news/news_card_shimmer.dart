import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView.builder(
      controller: PageController(viewportFraction: 0.9),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ClipRSuperellipse(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
