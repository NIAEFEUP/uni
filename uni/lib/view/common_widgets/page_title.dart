import 'package:flutter/material.dart';

/// Generic implementation of a page title
class PageTitle extends StatelessWidget {

  const PageTitle(
      {super.key, required this.name, this.center = true, this.pad = true,});
  final String name;
  final bool center;
  final bool pad;

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(
      name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).primaryTextTheme.headlineMedium?.color,),
    );
    return Container(
      padding: pad ? const EdgeInsets.fromLTRB(20, 20, 20, 10) : null,
      alignment: center ? Alignment.center : null,
      child: title,
    );
  }
}
