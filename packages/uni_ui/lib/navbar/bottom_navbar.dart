import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.house(PhosphorIconsStyle.duotone),
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.graduationCap(PhosphorIconsStyle.duotone),
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.forkKnife(PhosphorIconsStyle.duotone),
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.buildings(PhosphorIconsStyle.duotone),
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.mapTrifold(PhosphorIconsStyle.duotone),
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
