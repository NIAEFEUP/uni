import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/courses/course_info.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.courseInfo,
    required this.selected,
    required this.nowText,
    required this.onTap,
  });

  final CourseInfo courseInfo;
  final bool selected;
  final String nowText;
  final void Function() onTap;

  String _getYearText() {
    if (courseInfo.enrollmentYear == null) {
      return '';
    }

    if (courseInfo.conclusionYear == null) {
      return nowText;
    }

    return '${courseInfo.enrollmentYear!}/${courseInfo.conclusionYear!}';
  }

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      onClick: onTap,
      color: selected
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : grayLight,
      tooltip: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UniIcon(
                _getIconData(courseInfo.abbreviation, selected),
                size: 32,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : grayMiddle,
              ),
              Text(
                courseInfo.abbreviation,
                style: Theme.of(context).textTheme.titleLarge?.apply(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : grayMiddle,
                ),
              ),
              Text(
                _getYearText(),
                style: Theme.of(context).textTheme.bodySmall?.apply(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : grayMiddle,
                ),
              ),
            ],
          ),
        ),
      ),
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
      blurRadius: 2,
    );
  }

  static PhosphorIconData _getIconData(String abbreviation, bool selected) {
    final iconStyle = selected
        ? PhosphorIconsStyle.duotone
        : PhosphorIconsStyle.regular;

    switch (abbreviation[0]) {
      case 'L':
        return PhosphorIcons.graduationCap(iconStyle);
      case 'P':
        return PhosphorIcons.student(iconStyle);
      default:
        return PhosphorIcons.certificate(iconStyle);
    }
  }
}
