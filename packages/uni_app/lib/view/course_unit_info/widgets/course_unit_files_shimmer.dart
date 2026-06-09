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
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: SizedBox(
            height: 80,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
              highlightColor: Theme.of(context).disabledColor,
              child: GenericSquircle(
                child: Container(height: 35, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
