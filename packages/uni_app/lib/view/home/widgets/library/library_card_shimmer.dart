import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ShimmerLibraryHomeCard extends StatelessWidget {
  const ShimmerLibraryHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
      highlightColor: Theme.of(context).disabledColor,
      child: GenericSquircle(
        child: Container(
          height: 200,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
