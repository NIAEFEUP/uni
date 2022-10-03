import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/utils/constants.dart' as constants;

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
      required this.onNullContent})
      : super(key: key);

  final BuildContext context;
  final RequestStatus status;
  final Widget Function(dynamic, BuildContext) contentGenerator;
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
            return contentChecker
                ? contentGenerator(content, context)
                : const Center(child: CircularProgressIndicator());
          case RequestStatus.failed:
          default:
            return contentChecker
                ? contentGenerator(content, context)
                : requestFaildMessage();
        }
      },
    );
  }

  Widget requestFaildMessage() {
    return FutureBuilder(
        future: Connectivity().checkConnectivity(),
        builder: (BuildContext context, AsyncSnapshot connectivitySnapshot) {
          if (connectivitySnapshot.hasData) {
            if (connectivitySnapshot.data == ConnectivityResult.none) {
              return Center(
                  heightFactor: 3,
                  child: Text('Sem ligação à internet',
                      style: Theme.of(context).textTheme.subtitle1));
            }
          }
          return Column(children: [
            Center(
                heightFactor: 1.5,
                child: Text(
                    'Aconteceu um erro ao carregar os dados',
                    style: Theme.of(context).textTheme.subtitle1)),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, '/${constants.navBugReport}'),
                child: Text('Reportar erro',
                  style: Theme.of(context).textTheme.bodyText2))
          ]);
        });
  }
}
