import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/HomePageModel.dart';
import 'package:app_feup/redux/Actions.dart';
import 'package:app_feup/view/Widgets/ExamCard.dart';
import 'package:app_feup/view/Widgets/ScheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../Theme.dart';
import 'AccountInfoCard.dart';
import 'BusStopCard.dart';
import 'HomePageBackButton.dart';
import 'PrintInfoCard.dart';

class MainCardsList extends StatelessWidget {
  
  final Map<FAVORITE_WIDGET_TYPE, Function> CARD_CREATORS = {
    FAVORITE_WIDGET_TYPE.SCHEDULE: (k, em, od) => ScheduleCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.EXAMS: (k, em, od) => ExamCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.ACCOUNT: (k, em, od) => AccountInfoCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.PRINT_BALANCE: (k, em, od) => PrintInfoCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.BUS_STOPS: (k, em, od) => BusStopCard.fromEditingInformation(k, em, od)
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: HomePageBackButton(
          context: context,
          child:  createScrollableCardView(context),
        ),
        floatingActionButton: this.isEditing(context) ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Escolhe um widget para adicionares à tua página inicial:"),
              content: Container(
                child:
                  ListView(
                    children: getCardAdders(context)
                  ),
                height: 200.0,
                width: 100.0,
              ),
              actions: [FlatButton(child: Text("Cancelar", style: Theme.of(context).textTheme.display1.apply(color: Theme.of(context).primaryColor),), onPressed: () => Navigator.pop(context))]
            );
          }
        )
      , //Add FAB functionality here
      tooltip: 'Add widget',
      child: Icon(Icons.add),
    );
  }

  List<Widget> getCardAdders(BuildContext context){
    List<Widget> result = [];
    this.CARD_CREATORS.forEach((FAVORITE_WIDGET_TYPE key, Function v) {
      if(!StoreProvider.of<AppState>(context).state.content["favoriteCards"].contains(key))
      result.add(
          Container(
            child: ListTile(
              title: Text(
                v(Key(key.index.toString()), false, null).getTitle(),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                addCardToFavorites(key, context);
                Navigator.pop(context);
              },
            ),
            decoration: BoxDecoration(
                border: Border(bottom: new BorderSide(color: accentColor))),
          )
      );
    });
    if(result.isEmpty){
      result.add(new Text("Todos os widgets disponíveis já foram adicionados aos teus favoritos!"));
    }
    return result;
  }

  Widget createScrollableCardView(BuildContext context) {
    return StoreConnector<AppState, List<FAVORITE_WIDGET_TYPE>>(
        converter: (store) => store.state.content['favoriteCards'],
        builder: (context, favoriteWidgets) {
          return Container(height: MediaQuery.of(context).size.height,child:
          ReorderableListView(
            onReorder: (oldi, newi) => this.reorderCard(oldi, newi, favoriteWidgets, context),
            header: this.createTopBar(context),
            children: this.createFavoriteWidgetsFromTypes(favoriteWidgets, context),
            //Cards go here
          ));
        }
    );
  }

  Widget createTopBar(BuildContext context){

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 1.3),
            ),
            GestureDetector(
                onTap: () => StoreProvider.of<AppState>(context).dispatch(new SetHomePageEditingMode(!this.isEditing(context))),
                child: Text(
                  this.isEditing(context) ? 'Concluir Edição' : 'Editar',
                  style: Theme.of(context).textTheme.subtitle.apply(decoration: TextDecoration.underline),
                )
            )
          ]),
    );
  }

  List<Widget> createFavoriteWidgetsFromTypes(List<FAVORITE_WIDGET_TYPE> cards, BuildContext context) {
    if(cards == null) return [];

    List<Widget> result = List<Widget>();
    for(int i = 0; i < cards.length; i++) {
      result.add(this.createFavoriteWidgetFromType(cards[i], i, context));
    }
    return result;
  }

  Widget createFavoriteWidgetFromType(FAVORITE_WIDGET_TYPE type, int i, BuildContext context){
    return this.CARD_CREATORS[type](Key(i.toString()), this.isEditing(context), () => removeFromFavorites(i, context));
  }


  void reorderCard(int oldIndex, int newIndex, List<FAVORITE_WIDGET_TYPE> favorites, BuildContext context) {
    FAVORITE_WIDGET_TYPE tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    StoreProvider.of<AppState>(context).dispatch(new UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void removeFromFavorites(int i, BuildContext context) {
    List<FAVORITE_WIDGET_TYPE> favorites = StoreProvider.of<AppState>(context).state.content["favoriteCards"];
    favorites.removeAt(i);
    StoreProvider.of<AppState>(context).dispatch(new UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void addCardToFavorites(FAVORITE_WIDGET_TYPE type, BuildContext context){
    List<FAVORITE_WIDGET_TYPE> favorites = StoreProvider.of<AppState>(context).state.content["favoriteCards"];
    if(!favorites.contains(type)) {
      favorites.add(type);
    }
    StoreProvider.of<AppState>(context).dispatch(new UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }
  
  bool isEditing(context){
    bool result = StoreProvider
        .of<AppState>(context)
        .state
        .content['homePageEditingMode'];
    if(result == null) return false;
    return result;
  }
}