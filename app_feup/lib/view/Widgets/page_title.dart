import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageTitle extends StatelessWidget {
  final String name;

  const PageTitle({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Text(
        name,
        style: Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),
      ),
    );
  }
}
