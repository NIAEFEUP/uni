import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends StatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Scaffold getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: getTopNavbar(context),
      bottomNavigationBar: const AppBottomNavbar(),
      body: RefreshState(
        onRefresh: onRefresh,
        header: getHeader(context),
        body: body,
      ),
    );
  }

  @override
  String? getTitle();

  @override
  @nonVirtual
  AppTopNavbar? getTopNavbar(BuildContext context) {
    return AppTopNavbar(
      title: getTitle(),
      centerTitle: true,
      leftButton: BackButton(
        style: ButtonStyle(
          iconColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
        ),
      ),
      rightButton: getTopRightButton(context),
    );
  }
}
