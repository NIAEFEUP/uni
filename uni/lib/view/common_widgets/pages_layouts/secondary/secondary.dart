import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Scaffold getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: refreshState(context, body),
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }
}
