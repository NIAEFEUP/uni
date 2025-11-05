import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';
import 'package:uni_ui/theme.dart';

class NoExamsWidget extends StatelessWidget {
  const NoExamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/vacation.png',
      label: S.of(context).no_exams_label,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).primaryVibrant,
      ),
      sublabel: S.of(context).no_exams,
      sublabelTextStyle: Theme.of(context).bodyLarge,
    );
  }
}
