import 'package:flutter/material.dart';

/// Manages the app section displayed when the user presses the back button
class BackButtonExitWrapper extends StatelessWidget {
  const BackButtonExitWrapper({
    required this.context,
    required this.child,
    super.key,
  });

  final BuildContext context;
  final Widget child;



  @override
  Widget build(BuildContext context) {
    return child;
  }
}
