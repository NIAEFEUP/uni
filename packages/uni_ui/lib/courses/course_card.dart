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

  Color get grayColor => Colors.grey.shade100;
  Color get onGrayColor => Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      key: key,
      onClick: onTap,
      color: selected
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : grayColor,
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
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : onGrayColor,
              ),
              Text(
                courseInfo.abbreviation,
                style: Theme.of(context).textTheme.titleLarge?.apply(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : onGrayColor),
              ),
              Text(
                courseInfo.conclusionYear == null
                    ? 'now'
                    : '${courseInfo.enrollmentYear}/${courseInfo.conclusionYear}',
                style: Theme.of(context).textTheme.bodySmall?.apply(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : onGrayColor),
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
