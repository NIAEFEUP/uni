import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/secondary_page_back_button.dart';

import 'general_page_view.dart';

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
