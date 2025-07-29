import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni_ui/timeline/timeline.dart';
import '../../locale_notifier.dart';

class ShimmerExamPage extends StatelessWidget {
  const ShimmerExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final allMonths = List.generate(12, (index) => index + 1);
    final tabs =
        allMonths.map((month) {
          final date = DateTime(DateTime.now().year, month);
          return SizedBox(
            width: 30,
            height: 34,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    date.shortMonth(
                      Provider.of<LocaleNotifier>(context).getLocale(),
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${date.month}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList();
    // TODO: make timeline more empty content-proof
    return Timeline(
      tabs: tabs,
      content: List.generate(12, (index) {
        final date = DateTime(DateTime.now().year, index + 1);
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  date.fullMonth(
                    Provider.of<LocaleNotifier>(context).getLocale(),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                  maxLines: 1,
                ),
              ),
              const ShimmerTimelineItem(),
              const ShimmerTimelineItem(),
            ],
          ),
        );
      }),
      initialTab: currentMonth - 1,
      tabEnabled: List.generate(12, (index) {
        final month = index + 1;
        return month >= currentMonth;
      }),
    );
  }
}
