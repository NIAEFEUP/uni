import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';

abstract class GeneralPageViewState<T extends StatefulWidget> extends State<T> {
  bool _loadedOnce = false;
  bool _loading = true;
  bool _connected = true;

  // Function called when the user pulls down the screen to refresh
  Future<void> onRefresh(BuildContext context);

  // Function called when the page is loaded
  Future<void> onLoad(BuildContext context) async {}

  // Right action button on the top navigation bar
  Widget? getTopRightButton(BuildContext context) {
    return null;
  }

  // Top navigation bar
  AppTopNavbar? getTopNavbar(BuildContext context) {
    return AppTopNavbar(
      title: this.getTitle(),
      rightButton: getTopRightButton(context),
    );
  }

  // This is the widget that will be displayed above the body and below the top navigation bar
  Widget? getHeader(BuildContext context) {
    return null;
  }

  // The title of the page
  String? getTitle();

  // The content of the page
  Widget getBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_loadedOnce || !mounted) {
        return;
      }
      _loadedOnce = true;
      setState(() {
        _loading = true;
      });

      try {
        await onLoad(context);
      } catch (err, st) {
        if (err is SocketException) {
          setState(() {
            _connected = false;
          });
        } else {
          Logger().e('Failed to load page info: $err\n$st');
          await Sentry.captureException(err, stackTrace: st);
        }
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });

    // TODO:(thePeras): Is this stills a thing?
    if (!_connected) {
      return getScaffold(
        context,
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: ImageLabel(
              imagePath: 'assets/images/no_wifi.png',
              label: S.of(context).no_internet,
              labelTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              sublabel: S.of(context).check_internet,
            ),
          ),
        ),
      );
    }

    return getScaffold(
      context,
      _loading
          ? const Center(child: CircularProgressIndicator())
          : getBody(context),
    );
  }

  Widget getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: getTopNavbar(context),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const AppBottomNavbar(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      body: RefreshState(
        onRefresh: onRefresh,
        header: getHeader(context),
        body: body,
      ),
    );
  }
}
