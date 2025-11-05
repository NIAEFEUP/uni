import 'package:flutter/widgets.dart';
import 'package:uni_ui/common/generic_squircle.dart';
import 'package:uni_ui/theme.dart';

class ModalDialog extends StatelessWidget {
  const ModalDialog({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: transparent,
      child: GenericSquircle(
        borderRadius: 30,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Theme.of(context).secondary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
