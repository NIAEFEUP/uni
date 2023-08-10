import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.contentLoadingWidget, super.key});

  final Widget? contentLoadingWidget;

  @override
  Widget build(BuildContext context) {
    return contentLoadingWidget == null
        ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          )
        : Center(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).highlightColor,
              highlightColor: Theme.of(context).colorScheme.onPrimary,
              child: contentLoadingWidget!,
            ),
          );
  }

  Widget requestFailedMessage() {
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
              'Sem ligação à internet',
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
                  'Aconteceu um erro ao carregar os dados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/${DrawerItem.navBugReport.title}',
              ),
              child: const Text('Reportar erro'),
            )
          ],
        );
      },
    );
  }
}
