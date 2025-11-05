import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';
import 'package:uni_ui/theme.dart';

class NoFilesWidget extends StatelessWidget {
  const NoFilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/files.png',
      label: S.of(context).no_files_label,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).primaryVibrant,
      ),
      sublabel: S.of(context).no_files,
      sublabelTextStyle: const TextStyle(fontSize: 15),
    );
  }
}
