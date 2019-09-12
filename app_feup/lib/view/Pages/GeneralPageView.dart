import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_feup/view/Widgets/NavigationDrawer.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/model/ProfilePageModel.dart';

abstract class GeneralPageView extends StatelessWidget {
  final double borderMargin = 18.0;

  @override
  Widget build(BuildContext context) {
    return this.getScaffold(context, getBody(context));
  }

  Widget getBody(BuildContext context) {
    return new Container();
  }

  DecorationImage buildDecorageImage(context) {
    String studentNo = StoreProvider.of<AppState>(context)
            .state
            .content['session']
            .studentNumber ??
        "";
    return (studentNo != "")
        ? DecorationImage(
            fit: BoxFit.cover, image: getProfileImage(context))
        : null;
  }

  CachedNetworkImageProvider getProfileImage(BuildContext context) {
    CachedNetworkImageProvider profileImage;

    String studentNo = StoreProvider.of<AppState>(context).state.content['session'].studentNumber;
    String url = "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=" + studentNo;

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = StoreProvider.of<AppState>(context).state.content['session'].cookies;

    profileImage = CachedNetworkImageProvider(url, headers: headers);

    return profileImage;
  }

  Widget refreshState(BuildContext context, Widget child) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () => handleRefresh(store);
      },
      builder: (context, refresh) {
        return new RefreshIndicator(
            key: new GlobalKey<RefreshIndicatorState>(),
            child: child,
            onRefresh: refresh,
            color: Theme.of(context).primaryColor);
      },
    );
  }

  Widget getScaffold(BuildContext context, Widget body){
    MediaQueryData queryData = MediaQuery.of(context);
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: new AppBar(
        bottom: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(left: borderMargin, right: borderMargin),
            color: Theme.of(context).accentColor,
            height: 1.0,
          ),
          preferredSize: null,
        ),
        elevation: 0,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).backgroundColor,
        title: ButtonTheme(
          minWidth: 0,
          padding: EdgeInsets.only(left: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(),
          child: FlatButton(
              onPressed: () => Navigator.pushNamed(context, '/Área Pessoal'),
              child: SvgPicture.asset(
                    'assets/images/logo_dark.svg',
                      height: queryData.size.height/25,
                  ),
            )
        ),
        actions: <Widget>[
          getTopRightButton(context),
        ],),
      drawer: new NavigationDrawer(),
      body: this.refreshState(context, body),
    );
  }

  Widget getTopRightButton(BuildContext context) {
    return FlatButton(
          onPressed: () => {Navigator.push(context,new MaterialPageRoute(builder: (__) => new ProfilePage()))},
          child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: buildDecorageImage(context)
              )
          ),
        );
  }

}
