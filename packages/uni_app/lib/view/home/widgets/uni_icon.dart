import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UniIcon extends StatelessWidget {
  const UniIcon({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(),
      child: SvgPicture.asset(
        colorFilter: ColorFilter.mode(
          iconColor ?? Theme.of(context).primaryColor,
          BlendMode.srcIn,
        ),
        'assets/images/logo_dark.svg',
        height: 35,
      ),
    );
  }
}
