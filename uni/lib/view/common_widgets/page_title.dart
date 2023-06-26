import 'package:flutter/material.dart';

/// Generic implementation of a page title
class PageTitle extends StatelessWidget {
  final String name;
  final bool center;
  final bool pad;

  const PageTitle(
      {Key? key, required this.name, this.center = true, this.pad = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(
      name,
      style: Theme.of(context).textTheme.headline4?.copyWith(
          color: Theme.of(context).primaryTextTheme.headline4?.color),
    );
    return Container(
      padding: pad ? const EdgeInsets.fromLTRB(20, 20, 20, 10) : null,
      alignment: center ? Alignment.center : null,
      child: title,
    );
  }
}
