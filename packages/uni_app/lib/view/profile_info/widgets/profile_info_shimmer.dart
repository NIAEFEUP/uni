import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerProfileInfoPage extends StatelessWidget {
  const ShimmerProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(
                        context,
                      ).disabledColor.withAlpha(0x7f),
                      highlightColor: Theme.of(context).disabledColor,
                      child: Container(
                        height: 40,
                        color: Colors.grey,
                        width: 250,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
                    highlightColor: Theme.of(context).disabledColor,
                    child: GenericSquircle(
                      child: Container(height: 200, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
