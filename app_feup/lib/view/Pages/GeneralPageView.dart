import 'package:app_feup/controller/LifecycleEventHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_feup/view/Widgets/NavigationDrawer.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/model/ProfilePageModel.dart';
import 'dart:io';

abstract class GeneralPageViewState extends State<StatefulWidget> {
  final double borderMargin = 18.0;
  WidgetsBindingObserver lifeCycleEventHandler;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.lifeCycleEventHandler = new LifecycleEventHandler(store: StoreProvider.of<AppState>(context));
    WidgetsBinding.instance.addObserver(this.lifeCycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this.lifeCycleEventHandler);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return this.getScaffold(context, getBody(context));
  }

  Widget getBody(BuildContext context) {
    return new Container();
  }

  DecorationImage getDecorageImage(File x) {
    final image = (x == null)? new AssetImage("assets/images/profile_placeholder.png") : new FileImage(x);
    return  DecorationImage(
        fit: BoxFit.cover, image: image);
  }

  Future<DecorationImage> buildDecorageImage(context) async{
    var storedFile = await loadProfilePic( StoreProvider.of<AppState>(context));
    return getDecorageImage(storedFile);
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
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context),
      drawer: new NavigationDrawer(parentContext: context),
      body: this.refreshState(context, body),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return new AppBar(
      bottom: PreferredSize(
        child: Container(
          margin: EdgeInsets.only(left: borderMargin, right: borderMargin),
          color: Theme.of(context).accentColor,
          height: 1.5,
        ),
      ),
      elevation: 0,
      iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      titleSpacing: 0.0,
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
      )),
      actions: <Widget>[
        getTopRightButton(context),],
      );
  }

  Widget getTopRightButton(BuildContext context) {
    return FutureBuilder(
        future: buildDecorageImage(context),
        builder: (BuildContext context,
            AsyncSnapshot<DecorationImage> decorationImage) {
          return FlatButton(
          onPressed: () => {Navigator.push(context,new MaterialPageRoute(builder: (__) => new ProfilePage()))
          },child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: decorationImage.data
          )),
        );
      });
    }

}
