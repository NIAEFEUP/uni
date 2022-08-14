import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/PagesLayouts/General/general.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: refreshState(context, body),
    );
  }
}
