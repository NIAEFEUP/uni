import 'package:flutter/material.dart';

abstract class GenericHomecard extends StatelessWidget {
  const GenericHomecard({required this.title, super.key});

  final String title;

  Widget buildCardContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        buildCardContent(context),
      ],
    );
  }
}
