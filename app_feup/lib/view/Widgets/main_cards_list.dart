import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/home_page_model.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/account_info_card.dart';
import 'package:uni/view/Widgets/back_button_exit_wrapper.dart';
import 'package:uni/view/Widgets/bus_stop_card.dart';
import 'package:uni/view/Widgets/exam_card.dart';
import 'package:uni/view/Widgets/print_info_card.dart';
import 'package:uni/view/Widgets/schedule_card.dart';

class MainCardsList extends StatelessWidget {
  final Map<FAVORITE_WIDGET_TYPE, Function> cardCreators = {
    FAVORITE_WIDGET_TYPE.schedule: (k, em, od) =>
        ScheduleCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.exams: (k, em, od) =>
        ExamCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.account: (k, em, od) =>
        AccountInfoCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.printBalance: (k, em, od) =>
        PrintInfoCard.fromEditingInformation(k, em, od),
    FAVORITE_WIDGET_TYPE.busStops: (k, em, od) =>
        BusStopCard.fromEditingInformation(k, em, od)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackButtonExitWrapper(
        context: context,
        child: createScrollableCardView(context),
      ),
      floatingActionButton:
          this.isEditing(context) ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    'Escolhe um widget para adicionares à tua área pessoal:'),
                content: Container(
                  child: ListView(children: getCardAdders(context)),
                  height: 200.0,
                  width: 100.0,
                ),
                actions: [
                  TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context))
                ]);
          }), //Add FAB functionality here
      tooltip: 'Adicionar widget',
      child: Icon(Icons.add),
    );
  }

  List<Widget> getCardAdders(BuildContext context) {
    final List<Widget> result = [];
    this.cardCreators.forEach((FAVORITE_WIDGET_TYPE key, Function v) {
      if (!StoreProvider.of<AppState>(context)
          .state
          .content['favoriteCards']
          .contains(key)) {
        result.add(Container(
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
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
        ));
      }
    });
    if (result.isEmpty) {
      result.add(Text(
          '''Todos os widgets disponíveis já foram adicionados à tua área pessoal!'''));
    }
    return result;
  }

  Widget createScrollableCardView(BuildContext context) {
    return StoreConnector<AppState, List<FAVORITE_WIDGET_TYPE>>(
        converter: (store) => store.state.content['favoriteCards'],
        builder: (context, favoriteWidgets) {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: ReorderableListView(
                onReorder: (oldi, newi) =>
                    this.reorderCard(oldi, newi, favoriteWidgets, context),
                header: this.createTopBar(context),
                children: this
                    .createFavoriteWidgetsFromTypes(favoriteWidgets, context),
                //Cards go here
              ));
        });
  }

  Widget createTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          Constants.navPersonalArea,
          style:
              Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3),
        ),
        GestureDetector(
            onTap: () => StoreProvider.of<AppState>(context)
                .dispatch(SetHomePageEditingMode(!this.isEditing(context))),
            child: Text(this.isEditing(context) ? 'Concluir Edição' : 'Editar',
                style: Theme.of(context).textTheme.caption))
      ]),
    );
  }

  List<Widget> createFavoriteWidgetsFromTypes(
      List<FAVORITE_WIDGET_TYPE> cards, BuildContext context) {
    if (cards == null) return [];

    final List<Widget> result = <Widget>[];
    for (int i = 0; i < cards.length; i++) {
      result.add(this.createFavoriteWidgetFromType(cards[i], i, context));
    }
    return result;
  }

  Widget createFavoriteWidgetFromType(
      FAVORITE_WIDGET_TYPE type, int i, BuildContext context) {
    return this.cardCreators[type](Key(i.toString()), this.isEditing(context),
        () => removeFromFavorites(i, context));
  }

  void reorderCard(int oldIndex, int newIndex,
      List<FAVORITE_WIDGET_TYPE> favorites, BuildContext context) {
    final FAVORITE_WIDGET_TYPE tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void removeFromFavorites(int i, BuildContext context) {
    final List<FAVORITE_WIDGET_TYPE> favorites =
        StoreProvider.of<AppState>(context).state.content['favoriteCards'];
    favorites.removeAt(i);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void addCardToFavorites(FAVORITE_WIDGET_TYPE type, BuildContext context) {
    final List<FAVORITE_WIDGET_TYPE> favorites =
        StoreProvider.of<AppState>(context).state.content['favoriteCards'];
    if (!favorites.contains(type)) {
      favorites.add(type);
    }
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  bool isEditing(context) {
    final bool result = StoreProvider.of<AppState>(context)
        .state
        .content['homePageEditingMode'];
    if (result == null) return false;
    return result;
  }
}
