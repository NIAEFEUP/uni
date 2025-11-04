import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/top_navigation_bar.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends ConsumerStatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Widget getScaffold(BuildContext context, Widget body) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: getTopNavbar(context),
        body: RefreshState(
          onRefresh: onRefresh,
          header: getHeader(context),
          body: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: getBody(context),
          ),
        ),
      ),
    );
  }

  @override
  String? getTitle();

  String? getSubtitle() => null;

  @override
  @nonVirtual
  AppTopNavbar? getTopNavbar(BuildContext context) {
    return AppTopNavbar(
      title: getTitle(),
      subtitle: getSubtitle(),
      centerTitle: true,
      leftButton: BackButton(
        style: ButtonStyle(
          iconColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      rightButton: getRightContent(context),
    );
  }
}
