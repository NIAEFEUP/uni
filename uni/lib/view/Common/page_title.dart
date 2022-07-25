import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String name;
  final bool center;

  const PageTitle({Key? key, required this.name, this.center = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      name,
      style: Theme.of(context).textTheme.headline4?.copyWith(
          color: Theme.of(context).primaryTextTheme.headline4?.color),
    );
    if (center) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        alignment: Alignment.center,
        child: title,
      );
    }
    return title;
  }
}
