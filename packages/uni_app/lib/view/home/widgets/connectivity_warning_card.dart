import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/view/theme.dart';

class ConnectivityWarning extends StatelessWidget {
  const ConnectivityWarning({super.key});

  /*
  * TODO:
  * Change the language of the text accordingly to the theme
  */
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/circle-alert.svg',
          colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColor,
            BlendMode.srcIn,
          ),
          width: 21,
          height: 21,
          ),
          const SizedBox(width: 8),
          Text(
            'No Internet Connection Available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
