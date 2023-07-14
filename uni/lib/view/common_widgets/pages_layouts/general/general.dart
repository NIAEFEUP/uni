import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/navigation_drawer.dart';
import 'package:uni/view/profile/profile.dart';

/// Page with a hamburger menu and the user profile picture
abstract class GeneralPageViewState<T extends StatefulWidget> extends State<T> {
  final double borderMargin = 18.0;
  static ImageProvider? profileImageProvider;

  Future<void> handleRefresh(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return getScaffold(context, getBody(context));
  }

  Widget getBody(BuildContext context) {
    return Container();
  }

  Future<DecorationImage> buildProfileDecorationImage(context,
      {forceRetrieval = false}) async {
    final profilePictureFile =
        await ProfileProvider.fetchOrGetCachedProfilePicture(
            Provider.of<SessionProvider>(context, listen: false).session,
            forceRetrieval: forceRetrieval || profileImageProvider == null);
    return getProfileDecorationImage(profilePictureFile);
  }

  /// Returns the current user image.
  ///
  /// If the image is not found / doesn't exist returns a generic placeholder.
  DecorationImage getProfileDecorationImage(File? profilePicture) {
    final fallbackPicture = profileImageProvider ??
        const AssetImage('assets/images/profile_placeholder.png');
    final ImageProvider image =
        profilePicture == null ? fallbackPicture : FileImage(profilePicture);

    final result = DecorationImage(fit: BoxFit.cover, image: image);
    if (profilePicture != null) {
      profileImageProvider = image;
    }
    return result;
  }

  Widget refreshState(BuildContext context, Widget child) {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      onRefresh: () => ProfileProvider.fetchOrGetCachedProfilePicture(
              Provider.of<SessionProvider>(context, listen: false).session,
              forceRetrieval: true)
          .then((value) => handleRefresh(context)),
      child: child,
    );
  }

  Widget getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: AppNavigationDrawer(parentContext: context),
      body: refreshState(context, body),
    );
  }

  /// Builds the upper bar of the app.
  ///
  /// This method returns an instance of `AppBar` containing the app's logo,
  /// an option button and a button with the user's picture.
  AppBar buildAppBar(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: Container(
          color: Theme.of(context).dividerColor,
          margin: EdgeInsets.only(left: borderMargin, right: borderMargin),
          height: 1.5,
        ),
      ),
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: 0.0,
      title: ButtonTheme(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(),
          child: TextButton(
            onPressed: () {
              final currentRouteName = ModalRoute.of(context)!.settings.name;
              if (currentRouteName != DrawerItem.navPersonalArea.title) {
                Navigator.pushNamed(
                    context, '/${DrawerItem.navPersonalArea.title}');
              }
            },
            child: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
              'assets/images/logo_dark.svg',
              height: queryData.size.height / 25,
            ),
          )),
      actions: <Widget>[
        getTopRightButton(context),
      ],
    );
  }

  // Gets a round shaped button with the photo of the current user.
  Widget getTopRightButton(BuildContext context) {
    return FutureBuilder(
        future: buildProfileDecorationImage(context),
        builder: (BuildContext context,
            AsyncSnapshot<DecorationImage> decorationImage) {
          return TextButton(
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (__) => const ProfilePageView()))
            },
            child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, image: decorationImage.data)),
          );
        });
  }
}
