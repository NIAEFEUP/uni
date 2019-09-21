import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RequestDependentWidgetBuilder extends StatelessWidget {
  const RequestDependentWidgetBuilder({
    Key key,
    @required this.context,
    @required this.status,
    @required this.contentGenerator,
    @required this.content,
    @required this.contentChecker,
    @required this.onNullContent,
  }) : super(key: key);

  final BuildContext context;
  final RequestStatus status;
  final Widget Function(dynamic, BuildContext) contentGenerator;
  final content;
  final bool contentChecker;
  final Widget onNullContent;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case RequestStatus.SUCCESSFUL:
        return contentChecker ? 
        contentGenerator(content, context): onNullContent;
      case RequestStatus.BUSY:
        return contentChecker ?
        contentGenerator(content, context)
            : Center(child: CircularProgressIndicator());
      case RequestStatus.FAILED:
        return contentChecker ?
        contentGenerator(content, context)
            : Center(child: Text(
            "Comunication error. Please check your internet connection.",
            style: Theme
                .of(context)
                .textTheme
                .display1));
      default:
        return Container();
    }
  }
}