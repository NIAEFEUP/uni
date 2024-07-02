import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/bug_report/widgets/form.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';

class BugReportPageView extends StatefulWidget {
  const BugReportPageView({super.key});

  @override
  State<StatefulWidget> createState() => BugReportPageViewState();
}

/// Manages the 'Bugs and sugestions' section of the app.
class BugReportPageViewState extends SecondaryPageViewState<BugReportPageView> {
  @override
  Widget getBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: const BugReportForm(),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}

  @override
  String? getTitle() {
    return null;
  }
}
