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
    return GestureDetector(
      onTap: onTap,
      child: GenericCard(
        key: key,
        color: selected
            ? Theme.of(context).colorScheme.surfaceDim
            : Theme.of(context).colorScheme.surfaceContainerLow,
        child: SizedBox(
          width: 80,
          child: Column(
            children: [
              PhosphorIcon(
                PhosphorIcons.certificate(
                  selected
                      ? PhosphorIconsStyle.duotone
                      : PhosphorIconsStyle.regular,
                ),
                size: 48,
              ),
              Text(
                courseInfo.abbreviation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
