import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';

class ConnectivityWarning extends StatelessWidget {
  const ConnectivityWarning({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
            S.of(context).internet_status_exception,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
