import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';

/// Wraps content given its fetch data from the redux store,
/// hydrating the component, displaying an empty message,
/// a connection error or a loading circular effect as appropriate

class RequestDependentWidgetBuilder extends StatelessWidget {
  const RequestDependentWidgetBuilder(
      {Key? key,
      required this.context,
      required this.status,
      required this.contentGenerator,
      required this.content,
      required this.contentChecker,
      required this.onNullContent,
      this.contentLoadingWidget})
      : super(key: key);

  final BuildContext context;
  final RequestStatus status;
  final Widget Function(dynamic, BuildContext) contentGenerator;
  final Widget? contentLoadingWidget;
  final dynamic content;
  final bool contentChecker;
  final Widget onNullContent;

  @override
  Widget build(BuildContext context) {
    if (status == RequestStatus.busy && !contentChecker) {
      return loadingWidget();
    } else if (status == RequestStatus.failed) {
      return requestFailedMessage();
    }

    return contentChecker ? contentGenerator(content, context) : onNullContent;
  }

  Widget loadingWidget() {
    return contentLoadingWidget == null
        ? const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator()))
        : Center(
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).highlightColor,
                highlightColor: Theme.of(context).colorScheme.onPrimary,
                child: contentLoadingWidget!));
  }

  Widget requestFailedMessage() {
    return FutureBuilder(
        future: Connectivity().checkConnectivity(),
        builder: (BuildContext context, AsyncSnapshot connectivitySnapshot) {
          if (connectivitySnapshot.hasData) {
            if (connectivitySnapshot.data == ConnectivityResult.none) {
              return Center(
                  heightFactor: 3,
                  child: Text('Sem ligação à internet',
                      style: Theme.of(context).textTheme.titleMedium));
            }
          }
          return Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Center(
                    child: Text('Aconteceu um erro ao carregar os dados',
                        style: Theme.of(context).textTheme.titleMedium))),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/${DrawerItem.navBugReport.title}'),
                child: const Text('Reportar erro'))
          ]);
        });
  }
}
