import 'package:flutter/widgets.dart';
import 'package:uni_ui/theme.dart';
import 'package:uni_ui/cards/generic_card.dart';

class CourseGradeCard extends StatelessWidget {
  const CourseGradeCard({
    required this.courseName,
    required this.ects,
    required this.grade,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final String courseName;
  final double ects;
  final String? grade;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GenericCard(
      key: key,
      tooltip: tooltip,
      onClick: onTap,
      margin: EdgeInsets.zero,
      color:
          grade == ''
              ? theme.secondary
              : ((double.tryParse(grade!) ?? 0) >= 10
                  ? theme.secondary
                  : const Color.fromARGB(255, 249, 247, 247)),
      child: SizedBox(
        height: 75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              courseName,
              style: theme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ects == ects.toInt() ? ects.toInt() : ects} ECTS',
                  style: theme.bodySmall,
                ),
                Text('${grade ?? ""}', style: theme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
