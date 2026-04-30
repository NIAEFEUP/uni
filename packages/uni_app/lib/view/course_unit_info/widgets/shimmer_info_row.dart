import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_ui/icons.dart';

class ShimmerInfoRow extends StatelessWidget {
  const ShimmerInfoRow({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryFixed,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        dense: true,
        leading: UniIcon(
          icon,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Theme.of(context).disabledColor.withAlpha(0x7f),
          highlightColor: Theme.of(context).disabledColor,
          child: Container(
            height: 14,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
