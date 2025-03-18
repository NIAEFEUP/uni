import 'package:flutter/material.dart';
import 'package:uni_ui/common/generic_squircle.dart';

class ModalDialog extends StatelessWidget {
  const ModalDialog({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GenericSquircle(
          borderRadius: 30,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          )),
    );
  }
}
