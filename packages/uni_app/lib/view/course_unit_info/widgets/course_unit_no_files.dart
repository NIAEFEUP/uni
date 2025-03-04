import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';

class NoFilesWidget extends StatelessWidget {
  const NoFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_files_label,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      sublabel: S.of(context).no_files,
      sublabelTextStyle: const TextStyle(fontSize: 15),
    );
  }
}
