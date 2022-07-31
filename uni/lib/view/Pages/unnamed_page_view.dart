import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';

/// TODO: CHANGE THIS DOC
/// Generic class implementation for the user's personal page view.
abstract class UnnamedPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: refreshState(context, body),
    );
  }
}
