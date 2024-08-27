import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

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
                radius: 3,
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
                  radius: 3,
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
