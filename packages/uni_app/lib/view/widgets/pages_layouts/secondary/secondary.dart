import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/top_navigation_bar.dart';
import 'package:uni_ui/theme.dart';

/// Page with a back button on top
abstract class SecondaryPageViewState<T extends ConsumerStatefulWidget>
    extends GeneralPageViewState<T> {
  @override
  Widget getScaffold(BuildContext context, Widget body) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).background,
        appBar: getTopNavbar(context),
        body: RefreshState(
          onRefresh: onRefresh,
          header: getHeader(context),
          body: getBody(context),
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
          iconColor: WidgetStateProperty.all(Theme.of(context).primaryVibrant),
        ),
      ),
      rightButton: getRightContent(context),
    );
  }
}
