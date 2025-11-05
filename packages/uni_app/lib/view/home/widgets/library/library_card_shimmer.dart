import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/common/generic_squircle.dart';
import 'package:uni_ui/theme.dart';

class ShimmerLibraryHomeCard extends StatelessWidget {
  const ShimmerLibraryHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).grayMiddle,
      highlightColor: Theme.of(context).grayLight,
      child: GenericSquircle(
        child: Container(
          height: 200,
          decoration: const BoxDecoration(color: white),
        ),
      ),
    );
  }
}
