import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/courses/course_info.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.courseInfo,
    required this.selected,
    required this.onTap,
  });

  final CourseInfo courseInfo;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      onClick: onTap,
      color: selected
          ? Theme.of(context).colorScheme.surfaceDim
          : Theme.of(context).colorScheme.surfaceContainerLow,
      tooltip: '',
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PhosphorIcon(
                _getIconData(courseInfo.abbreviation, selected),
                size: 32,
              ),
              Text(
                courseInfo.abbreviation,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                courseInfo.conclusionYear == null
                    ? 'now'
                    : '${courseInfo.enrollmentYear}/${courseInfo.conclusionYear}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static PhosphorIconData _getIconData(String abbreviation, bool selected) {
    final iconStyle =
        selected ? PhosphorIconsStyle.duotone : PhosphorIconsStyle.regular;

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
