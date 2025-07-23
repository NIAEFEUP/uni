import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/utils/navigation_items.dart';

class IntroductionScreenView extends StatefulWidget {
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenViewState();
}

class _IntroductionScreenViewState extends State<IntroductionScreenView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF280709),
      body: Stack(
        children: [
          Align(
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFF5F3),
                BlendMode.srcIn,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.75),
            child: GestureDetector(
              onTap: () async {
                if (context.mounted) {
                  await Navigator.pushReplacementNamed(
                    context,
                    '/${NavigationItem.navPersonalArea.route}',
                  );
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment(-0.24, -0.31),
                    colors: [Color(0xFF280709), Color(0xFF461014)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0xBF996B6E),
                      blurRadius: 22,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFFFF5F3),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
