import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/model/app_state.dart';
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
  static final AppLastUserInfoUpdateDatabase lastUpdateDatabase =
      AppLastUserInfoUpdateDatabase();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DateTime?>(
      converter: (store) => store.state.content['lastUserInfoUpdateTime'],
      builder: (context, lastUpdateTime) {
        switch (status) {
          case RequestStatus.successful:
          case RequestStatus.none:
            return contentChecker
                ? contentGenerator(content, context)
                : onNullContent;
          case RequestStatus.busy:
            if (lastUpdateTime != null) {
              return contentChecker
                  ? contentGenerator(content, context)
                  : onNullContent;
            }
            if (contentLoadingWidget != null) {
              return contentChecker
                  ? contentGenerator(content, context)
                  : Center(
                      child: Shimmer.fromColors(
                          baseColor: Theme.of(context).highlightColor,
                          highlightColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: contentLoadingWidget!));
            }
            return contentChecker
                ? contentGenerator(content, context)
                : const Center(child: CircularProgressIndicator());
          case RequestStatus.failed:
          default:
            return contentChecker
                ? contentGenerator(content, context)
                : requestFailedMessage();
        }
      },
    );
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
