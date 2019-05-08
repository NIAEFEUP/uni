import 'package:flutter/material.dart';
import '../Widgets/NavigationDrawer.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/model/ProfilePageModel.dart';

abstract class GeneralPageView extends StatelessWidget {

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
            child: child,
            onRefresh: refresh,
            color: Theme.of(context).primaryColor);
      },
    );
  }

  Widget getScaffold(BuildContext context, Widget body){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(StoreProvider.of<AppState>(context).state.content["selected_page"], textAlign: TextAlign.start),
        actions: <Widget>[
          FlatButton(
            onPressed: () => {Navigator.pushReplacement(context,new MaterialPageRoute(builder: (__) => new ProfilePage()))},
            child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: buildDecorageImage(context)
                )
            ),
          ),
        ],),
      drawer: new NavigationDrawer(),
      body: this.refreshState(context, body),
    );
  }

}
