import 'package:app_feup/controller/loadinfo.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class RefreshState extends StatelessWidget {
  final Widget child;
  RefreshState({
    Key key,
    @required this.child
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Future<void>>(
      converter: (store){
        return handleRefresh(store);
      },
      builder: (context, refresh){
        return new RefreshIndicator(
            child: this.child,
            onRefresh: () => refresh
        );
      },
    );
  }
}