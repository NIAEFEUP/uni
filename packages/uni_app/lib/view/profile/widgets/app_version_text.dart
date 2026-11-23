import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni/generated/l10n.dart';

class AppVersionText extends StatefulWidget {
  const AppVersionText({super.key});

  @override
   State<AppVersionText> createState() => _AppVersionTextState();
}

  class _AppVersionTextState extends State<AppVersionText> {
    int _tapCount = 0;
    bool _dialogOpen = false;
    Timer? _resetTimer;

     Future<void> _onTap() async {
      if (_dialogOpen) {
        return;}

      _tapCount++;
      _resetTimer?.cancel();
      _resetTimer =Timer(const Duration(seconds: 2), () => _tapCount = 0);


      if (_tapCount >= 5) {
      _tapCount = 0;
      _resetTimer?.cancel();
      _dialogOpen = true;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
            title: Text(S.of(dialogContext).easter_egg_title,
            textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            content:SizedBox(
              width: 160,
              height: 160,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(-6, 7),
                  child: SvgPicture.asset('assets/images/byte.svg',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,),
               ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  S.of(dialogContext).close,
                  style: const TextStyle(fontSize: 18),
                ),
            ),
          ],
        ),
      );
      _dialogOpen = false;
    }
  }


    @override
    void dispose() {
      _resetTimer?.cancel();
      super.dispose();
    }
    
    @override
    Widget build(BuildContext context){
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final info = snapshot.data!;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onTap,
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              S.of(context).settings_app_version(info.version),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ));
      },
    );
  }
}
