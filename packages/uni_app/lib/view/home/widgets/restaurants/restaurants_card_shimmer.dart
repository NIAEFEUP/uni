import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerRestaurantsHomeCard extends StatelessWidget {
  const ShimmerRestaurantsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView.builder(
      controller: PageController(viewportFraction: 0.9),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
            highlightColor: Theme.of(context).disabledColor,
            child: GenericSquircle(
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
