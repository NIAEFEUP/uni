import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/theme.dart';

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
          const SizedBox(width: 16),
          Text(
            S.of(context).login,
            style: lightTheme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF303030),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
