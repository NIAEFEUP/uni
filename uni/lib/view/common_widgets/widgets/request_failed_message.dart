import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/bug_report/bug_report.dart';

class RequestFailedMessage extends StatelessWidget {
  const RequestFailedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Connectivity().checkConnectivity(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ConnectivityResult> connectivitySnapshot,
      ) {
        if (!connectivitySnapshot.hasData) {
          return const Center(
            heightFactor: 3,
            child: CircularProgressIndicator(),
          );
        }

        if (connectivitySnapshot.data == ConnectivityResult.none) {
          return Center(
            heightFactor: 3,
            child: Text(
              S.of(context).check_internet,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Center(
                child: Text(
                  S.of(context).load_error,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<BugReportPageView>(
                  builder: (context) => const BugReportPageView(),
                ),
              ),
              child: Text(S.of(context).report_error),
            ),
          ],
        );
      },
    );
  }
}
