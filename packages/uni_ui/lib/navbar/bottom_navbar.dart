import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:uni_ui/navbar/bottom_navbar_item.dart';

class _BottomNavbarContainer extends StatelessWidget {
  _BottomNavbarContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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

class BottomNavbar extends StatefulWidget {
  BottomNavbar({super.key, required this.items});

  final List<BottomNavbarItem> items;

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  void _refresh() {
    setState(() {});
  }

  void _onTap(int index) {
    widget.items[index].onTap();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return _BottomNavbarContainer(
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          onTap: _onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 32,
          type: BottomNavigationBarType.fixed,
          items: widget.items.map((item) => item.toBottomNavigationBarItem(context)).toList(),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
