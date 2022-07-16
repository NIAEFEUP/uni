import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';

class BugReportPageView extends StatefulWidget {
  const BugReportPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BugReportPageViewState();
}

/// Manages the 'Bugs and sugestions' section of the app.
class BugReportPageViewState extends SecondaryPageView {
  @override
  Widget getBody(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: const BugReportForm());
  }
}
