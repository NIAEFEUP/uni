import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/bug_report/widgets/form.dart';
import 'package:uni/view/common_widgets/PagesLayouts/General/general.dart';

class BugReportPageView extends StatefulWidget {
  const BugReportPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BugReportPageViewState();
}

/// Manages the 'Bugs and sugestions' section of the app.
class BugReportPageViewState extends GeneralPageViewState<BugReportPageView> {
  @override
  Widget getBody(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: const BugReportForm());
  }
}
