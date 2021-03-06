import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:io';

import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/profile_page_model.dart';
import 'package:uni/view/Widgets/navigation_drawer.dart';
import 'package:uni/utils/constants.dart' as Constants;

abstract class GeneralPageViewState extends State<StatefulWidget> {
  final double borderMargin = 18.0;
  static FileImage decorageImage;

  @override
  Widget build(BuildContext context) {
    return this.getScaffold(context, getBody(context));
  }

  Widget getBody(BuildContext context) {
    return  Container();
  }

  DecorationImage getDecorageImage(File x) {
    final fallbackImage = decorageImage == null
        ?  AssetImage('assets/images/profile_placeholder.png')
        : decorageImage;

    final image = (x == null) ? fallbackImage :  FileImage(x);
    final result = DecorationImage(fit: BoxFit.cover, image: image);
    if (x != null) {
      decorageImage = image;
    }
    return result;
  }

  Future<DecorationImage> buildDecorageImage(context) async {
    final storedFile =
        await loadProfilePic(StoreProvider.of<AppState>(context));
    return getDecorageImage(storedFile);
  }

  Widget refreshState(BuildContext context, Widget child) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () => handleRefresh(store);
      },
      builder: (context, refresh) {
        return  RefreshIndicator(
            key:  GlobalKey<RefreshIndicatorState>(),
            child: child,
            onRefresh: refresh,
            color: Theme.of(context).primaryColor);
      },
    );
  }

  Widget getScaffold(BuildContext context, Widget body) {
    return  Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context),
      drawer:  NavigationDrawer(parentContext: context),
      body: this.refreshState(context, body),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return  AppBar(
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: Container(
          margin: EdgeInsets.only(left: borderMargin, right: borderMargin),
          color: Theme.of(context).accentColor,
          height: 1.5,
        ),
      ),
      elevation: 0,
      iconTheme:  IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      titleSpacing: 0.0,
      title: ButtonTheme(
          minWidth: 0,
          padding: EdgeInsets.only(left: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(),
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/' + Constants.navPersonalArea),
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              height: queryData.size.height / 25,
            ),
          )),
      actions: <Widget>[
        getTopRightButton(context),
      ],
    );
  }

  Widget getTopRightButton(BuildContext context) {
    return FutureBuilder(
        future: buildDecorageImage(context),
        builder: (BuildContext context,
            AsyncSnapshot<DecorationImage> decorationImage) {
          return TextButton(
            onPressed: () => {
              Navigator.push(context,
                   MaterialPageRoute(builder: (__) =>  ProfilePage()))
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
