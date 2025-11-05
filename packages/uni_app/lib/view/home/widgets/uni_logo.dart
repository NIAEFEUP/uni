import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni_ui/theme.dart';

class UniLogo extends StatelessWidget {
  const UniLogo({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(),
      child: SvgPicture.asset(
        colorFilter: ColorFilter.mode(
          iconColor ?? Theme.of(context).primaryVibrant,
          BlendMode.srcIn,
        ),
        'assets/images/logo_dark.svg',
        height: 35,
      ),
    );
  }
}
