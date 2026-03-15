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
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListTile(
        dense: true,
        leading: UniIcon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(height: 10, width: 140, color: Colors.white),
        ),
      ),
    );
  }
}
