import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';

class ConnectivityWarning extends StatelessWidget {
  const ConnectivityWarning({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      /*  Image with background (delete if necessary)
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
            color: Color.fromARGB(0x1c, 0, 0, 0),
            blurRadius: 7,
            offset: Offset(0, 1),
            ),
          ]
      ,),

       */
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      alignment: Alignment.center,
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
            //style: Theme.of(context).textTheme.bodyMedium,
            style: TextStyle(
             color: Theme.of(context).primaryColor
           ),
          ),
        ],
      ),
    );
  }
}
