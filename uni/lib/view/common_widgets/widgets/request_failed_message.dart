import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';

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
