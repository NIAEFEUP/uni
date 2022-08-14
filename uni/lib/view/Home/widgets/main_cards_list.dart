import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/Profile/widgets/account_info_card.dart';
import 'package:uni/view/Home/widgets/exit_app_dialog.dart';
import 'package:uni/view/Home/widgets/bus_stop_card.dart';
import 'package:uni/view/Home/widgets/exam_card.dart';
import 'package:uni/view/Common/page_title.dart';
import 'package:uni/view/Profile/widgets/print_info_card.dart';
import 'package:uni/view/Home/widgets/schedule_card.dart';

class MainCardsList extends StatelessWidget {
  final Map<FavoriteWidgetType, Function> cardCreators = {
    FavoriteWidgetType.schedule: (k, em, od) =>
        ScheduleCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.exams: (k, em, od) =>
        ExamCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.account: (k, em, od) =>
        AccountInfoCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.printBalance: (k, em, od) =>
        PrintInfoCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.busStops: (k, em, od) =>
        BusStopCard.fromEditingInformation(k, em, od)
  };

  MainCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackButtonExitWrapper(
        context: context,
        child: createScrollableCardView(context),
      ),
      floatingActionButton:
          isEditing(context) ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text(
                    'Escolhe um widget para adicionares à tua área pessoal:'),
                content: SizedBox(
                  height: 200.0,
                  width: 100.0,
                  child: ListView(children: getCardAdders(context)),
                ),
                actions: [
                  TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context))
                ]);
          }), //Add FAB functionality here
      tooltip: 'Adicionar widget',
      child: const Icon(Icons.add),
    );
  }

  List<Widget> getCardAdders(BuildContext context) {
    final List<Widget> result = [];
    cardCreators.forEach((FavoriteWidgetType key, Function v) {
      if (!StoreProvider.of<AppState>(context)
          .state
          .content['favoriteCards']
          .contains(key)) {
        result.add(Container(
          decoration: const BoxDecoration(),
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
        ));
      }
    });
    if (result.isEmpty) {
      result.add(const Text(
          '''Todos os widgets disponíveis já foram adicionados à tua área pessoal!'''));
    }
    return result;
  }

  Widget createScrollableCardView(BuildContext context) {
    return StoreConnector<AppState, List<FavoriteWidgetType>?>(
        converter: (store) => store.state.content['favoriteCards'],
        builder: (context, favoriteWidgets) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: isEditing(context)
                  ? ReorderableListView(
                      onReorder: (oldi, newi) => reorderCard(
                          oldi, newi, favoriteWidgets ?? [], context),
                      header: createTopBar(context),
                      children: createFavoriteWidgetsFromTypes(
                          favoriteWidgets ?? [], context),
                      //Cards go here
                    )
                  : ListView(
                      children: <Widget>[
                        createTopBar(context),
                        ...createFavoriteWidgetsFromTypes(
                            favoriteWidgets ?? [], context)
                      ],
                    ));
        });
  }

  Widget createTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const PageTitle(
            name: constants.navPersonalArea, center: false, pad: false),
        GestureDetector(
            onTap: () => StoreProvider.of<AppState>(context)
                .dispatch(SetHomePageEditingMode(!isEditing(context))),
            child: Text(isEditing(context) ? 'Concluir Edição' : 'Editar',
                style: Theme.of(context).textTheme.caption))
      ]),
    );
  }

  List<Widget> createFavoriteWidgetsFromTypes(
      List<FavoriteWidgetType> cards, BuildContext context) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < cards.length; i++) {
      result.add(createFavoriteWidgetFromType(cards[i], i, context));
    }
    return result;
  }

  Widget createFavoriteWidgetFromType(
      FavoriteWidgetType type, int i, BuildContext context) {
    return cardCreators[type]!(Key(i.toString()), isEditing(context),
        () => removeFromFavorites(i, context));
  }

  void reorderCard(int oldIndex, int newIndex,
      List<FavoriteWidgetType> favorites, BuildContext context) {
    final FavoriteWidgetType tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void removeFromFavorites(int i, BuildContext context) {
    final List<FavoriteWidgetType> favorites =
        StoreProvider.of<AppState>(context).state.content['favoriteCards'];
    favorites.removeAt(i);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  void addCardToFavorites(FavoriteWidgetType type, BuildContext context) {
    final List<FavoriteWidgetType> favorites =
        StoreProvider.of<AppState>(context).state.content['favoriteCards'];
    if (!favorites.contains(type)) {
      favorites.add(type);
    }
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteCards(favorites));
    AppSharedPreferences.saveFavoriteCards(favorites);
  }

  bool isEditing(context) {
    final result = StoreProvider.of<AppState>(context)
        .state
        .content['homePageEditingMode'];
    return result ?? false;
  }
}
