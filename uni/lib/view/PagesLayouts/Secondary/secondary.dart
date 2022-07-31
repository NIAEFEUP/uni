import 'package:flutter/material.dart';
import 'package:uni/view/PagesLayouts/Secondary/widgets/back_button.dart';
import 'package:uni/view/PagesLayouts/General/general.dart';

/// Generic class implementation for the secondary page view.
abstract class SecondaryPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Widget build(BuildContext context) {
    return getScaffold(context, bodyWrapper(context));
  }

  Widget bodyWrapper(BuildContext context) {
    return SecondaryPageBackButton(context: context, child: getBody(context));
  }
}
