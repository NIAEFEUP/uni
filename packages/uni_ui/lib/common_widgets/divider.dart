import 'package:flutter/widgets.dart';
import 'package:uni_ui/theme.dart';

class Divider extends StatelessWidget {
  const Divider({
    super.key,
    this.height = 1.0,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      height: height,
      color: color ?? Theme.of(context).divider,
    );
  }
}
