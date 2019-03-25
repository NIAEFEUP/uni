import 'package:flutter/material.dart';
import '../widgets/NavigationDrawer.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_feup/controller/loadinfo.dart';
import 'package:app_feup/model/ProfilePageModel.dart';


abstract class GeneralPageView extends StatelessWidget {

  // WidgetsBindingObserver lifeCycleEventHandler;

  @override
  Widget build(BuildContext context) {
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
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: getProfileImage(context)
                  )
                )
              ),
          ),
        ],),
      drawer: new NavigationDrawer(),
      body: this.refreshState(context, getBody(context)),
    );
  }

  Widget getBody(BuildContext context){return new Container();}

  CachedNetworkImageProvider getProfileImage(BuildContext context){
    CachedNetworkImageProvider profileImage;

    String studentNo = StoreProvider.of<AppState>(context).state.content['session']['studentNumber'];
    String url = "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=" + studentNo;

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = StoreProvider.of<AppState>(context).state.content['session']['cookies'];

    profileImage = CachedNetworkImageProvider(url, headers: headers);

    return profileImage;
  }

  Widget refreshState(BuildContext context, Widget child) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store){
        return () => handleRefresh(store);
      },
      builder: (context, refresh){
        return new RefreshIndicator(
            child: child,
            onRefresh: refresh,
            color: Theme.of(context).primaryColor
        );
      },
    );
  }



}
