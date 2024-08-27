import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/navbar/bottom_navbar_item.dart';

class _BottomNavbarContainer extends StatelessWidget {
  _BottomNavbarContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(20),
      height: 80,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 20,
          cornerSmoothing: 1,
        ),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary.withAlpha(0x3f),
                  Colors.transparent,
                ],
                center: Alignment(-0.5, -1.0),
                radius: 2.5,
              )
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary.withAlpha(0x3f),
                    Colors.transparent,
                  ],
                  center: Alignment.bottomRight,
                  radius: 2.5,
                )
              ),
              child: child,
            ),
          )
        ),
      ),
    );
  }
}

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return _BottomNavbarContainer(
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 32,
          type: BottomNavigationBarType.fixed,
          items: [
            PhosphorIcons.house(PhosphorIconsStyle.duotone),
            PhosphorIcons.graduationCap(PhosphorIconsStyle.duotone),
            PhosphorIcons.forkKnife(PhosphorIconsStyle.duotone),
            PhosphorIcons.buildings(PhosphorIconsStyle.duotone),
            PhosphorIcons.mapTrifold(PhosphorIconsStyle.duotone),
          ]
            .map((icon) => BottomNavbarItem(icon: icon))
            .map((item) => item.toBottomNavigationBarItem(context, true))
            .toList(),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
