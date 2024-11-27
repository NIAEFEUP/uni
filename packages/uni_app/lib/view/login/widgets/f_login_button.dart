import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/generated/l10n.dart';

class FLoginButton extends StatelessWidget {

  const FLoginButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/AAI.svg',
            height: 26,
          ),
          const SizedBox(width: 20),
          Text(
            S.of(context).login,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
