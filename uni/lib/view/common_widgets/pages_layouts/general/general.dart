import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';

/// Page with a hamburger menu and the user profile picture
abstract class GeneralPageViewState<T extends StatefulWidget> extends State<T> {
  bool _loadedOnce = false;
  bool _loading = true;

  Future<void> onRefresh(BuildContext context);

  Future<void> onLoad(BuildContext context) async {}

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
      } catch (e, stackTrace) {
        Logger().e('Failed to load page info: $e\n$stackTrace');
        await Sentry.captureException(e, stackTrace: stackTrace);
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });

    return getScaffold(
      context,
      _loading
          ? const Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )
          : getBody(context),
    );
  }

  String? getTitle();

  Widget getBody(BuildContext context);

  Future<DecorationImage> buildProfileDecorationImage(
    BuildContext context, {
    bool forceRetrieval = false,
  }) async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    await sessionProvider.ensureInitialized(context);
    final profilePictureFile =
        await ProfileProvider.fetchOrGetCachedProfilePicture(
      sessionProvider.state!,
      forceRetrieval: forceRetrieval,
    );
    return getProfileDecorationImage(profilePictureFile);
  }

  /// Returns the current user image.
  ///
  /// If the image is not found / doesn't exist returns a generic placeholder.
  DecorationImage getProfileDecorationImage(File? profilePicture) {
    const fallbackPicture = AssetImage('assets/images/profile_placeholder.png');
    final image =
        profilePicture == null ? fallbackPicture : FileImage(profilePicture);

    final result =
        DecorationImage(fit: BoxFit.cover, image: image as ImageProvider);
    return result;
  }

  Widget refreshState(BuildContext context, Widget child) {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      onRefresh: () => ProfileProvider.fetchOrGetCachedProfilePicture(
        Provider.of<SessionProvider>(context, listen: false).state!,
        forceRetrieval: true,
      ).then((value) => onRefresh(context)),
      child: Builder(
        builder: (context) => GestureDetector(
          onHorizontalDragEnd: (dragDetails) {
            if (dragDetails.primaryVelocity! > 2) {
              Scaffold.of(context).openDrawer();
            }
          },
          child: child,
        ),
      ),
    );
  }

  Widget getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavbar(),
      appBar: getTopNavbar(context),
      body: RefreshState(onRefresh: onRefresh, child: body),
    );
  }

  AppTopNavbar? getTopNavbar(BuildContext context) {
    return AppTopNavbar(
      title: this.getTitle(),
      rightButton: ProfileButton(
        getProfileDecorationImage: getProfileDecorationImage,
      ),
    );
  }
}
