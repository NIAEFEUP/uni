import 'package:flutter/material.dart';

class MoveIcon extends StatelessWidget {
  const MoveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.drag_handle_rounded,
      color: Colors.grey.shade500,
      size: 22,
    );
  }
}
