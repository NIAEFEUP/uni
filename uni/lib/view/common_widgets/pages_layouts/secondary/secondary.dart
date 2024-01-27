import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/app_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/refresh_state.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Scaffold getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: CustomAppBar(getTopRightButton: getTopRightButton),
      body: RefreshState(onRefresh: onRefresh, child: body),
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }
}
