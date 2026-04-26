import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class NoFilesWidget extends StatelessWidget {
  const NoFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/files.svg',
      label: S.of(context).no_files_label,
      labelTextStyle: Theme.of(context).textTheme.headlineLarge,
      sublabel: S.of(context).no_files,
      sublabelTextStyle: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
