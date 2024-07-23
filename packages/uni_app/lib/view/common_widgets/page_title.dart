import 'package:flutter/material.dart';

/// Generic implementation of a page title
class PageTitle extends StatelessWidget {
  const PageTitle({
    required this.name,
    super.key,
    this.center = true,
    this.pad = true,
  });
  final String name;
  final bool center;
  final bool pad;

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(
      name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).primaryTextTheme.headlineMedium?.color,
          ),
    );
    return Container(
      padding: pad ? const EdgeInsets.fromLTRB(20, 30, 20, 10) : null,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: title,
    );
  }
}
