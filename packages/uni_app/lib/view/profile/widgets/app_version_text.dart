import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';

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

    final ConfettiController _confetti = 
    ConfettiController (duration:const Duration(seconds:2));

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
      _confetti.play();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Stack(
          alignment: Alignment.topCenter,
          children: [
            AlertDialog(
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
                    fit: BoxFit.contain,
                    ),
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
        ConfettiWidget(
          confettiController: _confetti,
          blastDirection: (pi*3)/2,
          emissionFrequency: 0.03,
          numberOfParticles: 50,
          gravity: 0.2,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          colors: [const Color.fromARGB(255, 86, 15, 10), Colors.white],
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
      _confetti.dispose();
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
