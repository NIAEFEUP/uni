import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';
import 'package:uni_ui/theme.dart';

class NoClassesWidget extends StatelessWidget {
  const NoClassesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_classes,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).primaryVibrant,
      ),
      sublabel: S.of(context).no_classes_this_week,
      sublabelTextStyle: Theme.of(context).bodyLarge,
    );
  }
}
