import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/refresh_state.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';

/// Page with a hamburger menu and the user profile picture
abstract class GeneralPageViewState<T extends StatefulWidget> extends State<T> {
  bool _loadedOnce = false;
  bool _loading = true;
  bool _connected = true;

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

  Widget getHeader(BuildContext context) {
    return Container();
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

  Widget getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: const AppBottomNavbar(),
      body: RefreshState(
        onRefresh: onRefresh,
        header: getHeader(context),
        body: body,
      ),
    );
  }

  AppTopNavbar? getTopNavbar(BuildContext context) {
    return AppTopNavbar(
      title: this.getTitle(),
      rightButton: const ProfileButton(),
    );
  }
}
