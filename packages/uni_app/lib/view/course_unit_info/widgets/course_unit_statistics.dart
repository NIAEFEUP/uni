import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit_statistics.dart';
import 'package:uni_ui/theme.dart';

class CourseUnitStatisticsView extends StatelessWidget {
  const CourseUnitStatisticsView(this.statistics, {super.key});

  final CourseUnitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enrolled = statistics.enrolled;
    final allZero =
        statistics.approved == 0 &&
        statistics.failed == 0 &&
        statistics.notEvaluated == 0;

    double pct(int value) {
      return enrolled > 0 ? value / enrolled * 100 : 0.0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                S.of(context).statistics,
                style: theme.textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                S.of(context).statistics_distribution_description,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${S.of(context).enrolled}: ${statistics.enrolled}',
                style: theme.textTheme.bodyMedium?.copyWith(),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 36,
                child: Row(
                  children: [
                    if (allZero)
                      Expanded(child: Container(color: BadgeColors.noEval))
                    else ...[
                      if (statistics.approved > 0)
                        Expanded(
                          flex: statistics.approved,
                          child: Container(color: BadgeColors.approved),
                        ),
                      if (statistics.failed > 0)
                        Expanded(
                          flex: statistics.failed,
                          child: Container(color: BadgeColors.failed),
                        ),
                      if (statistics.notEvaluated > 0)
                        Expanded(
                          flex: statistics.notEvaluated,
                          child: Container(color: BadgeColors.noEval),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LegendItem(
                  color: BadgeColors.approved,
                  label:
                      '${statistics.approved} ${S.of(context).approved} (${pct(statistics.approved).toStringAsFixed(1)}%)',
                ),
                _LegendItem(
                  color: BadgeColors.failed,
                  label:
                      '${statistics.failed} ${S.of(context).failed} (${pct(statistics.failed).toStringAsFixed(1)}%)',
                ),
                _LegendItem(
                  color: BadgeColors.noEval,
                  label:
                      '${statistics.notEvaluated} ${S.of(context).not_evaluated} (${pct(statistics.notEvaluated).toStringAsFixed(1)}%)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 4),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color),
        ),
      ],
    );
  }
}
