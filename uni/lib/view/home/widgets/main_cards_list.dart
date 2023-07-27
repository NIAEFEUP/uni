import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/home/widgets/bus_stop_card.dart';
import 'package:uni/view/home/widgets/restaurant_card.dart';
import 'package:uni/view/home/widgets/exam_card.dart';
import 'package:uni/view/home/widgets/exit_app_dialog.dart';
import 'package:uni/view/home/widgets/schedule_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';
import 'package:uni/view/profile/widgets/account_info_card.dart';

typedef CardCreator = GenericCard Function(
    Key key, bool isEditingMode, dynamic Function()? onDelete);

class MainCardsList extends StatelessWidget {
  static Map<FavoriteWidgetType, CardCreator> cardCreators = {
    FavoriteWidgetType.schedule: (k, em, od) =>
        ScheduleCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.exams: (k, em, od) =>
        ExamCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.account: (k, em, od) =>
        AccountInfoCard.fromEditingInformation(k, em, od),

    // TODO: Bring print card back when it is ready
    /*FavoriteWidgetType.printBalance: (k, em, od) =>
        PrintInfoCard.fromEditingInformation(k, em, od),*/

    FavoriteWidgetType.busStops: (k, em, od) =>
        BusStopCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.libraryOccupation: (k, em, od) =>
        LibraryOccupationCard.fromEditingInformation(k, em, od),
    FavoriteWidgetType.restaurant: (k, em, od) =>
        RestaurantCard.fromEditingInformation(k, em, od)
  };

  const MainCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<HomePageProvider>(
        builder: (context, homePageProvider) => Scaffold(
              body: BackButtonExitWrapper(
                context: context,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: homePageProvider.isEditing
                        ? ReorderableListView(
                            onReorder: (oldIndex, newIndex) => reorderCard(
                                oldIndex,
                                newIndex,
                                homePageProvider.favoriteCards,
                                context),
                            header: createTopBar(context, homePageProvider),
                            children: favoriteCardsFromTypes(
                                homePageProvider.favoriteCards,
                                context,
                                homePageProvider),
                          )
                        : ListView(
                            children: <Widget>[
                              createTopBar(context, homePageProvider),
                              ...favoriteCardsFromTypes(
                                  homePageProvider.favoriteCards,
                                  context,
                                  homePageProvider)
                            ],
                          )),
              ),
              floatingActionButton: homePageProvider.isEditing
                  ? createActionButton(context)
                  : null,
            ));
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    'Escolhe um widget para adicionares à tua área pessoal:',
                    style: Theme.of(context).textTheme.headlineSmall),
                content: SizedBox(
                  height: 200.0,
                  width: 100.0,
                  child: ListView(children: getCardAdders(context)),
                ),
                actions: [
                  TextButton(
                      child: Text('Cancelar',
                          style: Theme.of(context).textTheme.bodyMedium),
                      onPressed: () => Navigator.pop(context))
                ]);
          }), //Add FAB functionality here
      tooltip: 'Adicionar widget',
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  List<Widget> getCardAdders(BuildContext context) {
    final session =
        Provider.of<SessionProvider>(context, listen: false).session;
    final List<FavoriteWidgetType> favorites =
        Provider.of<HomePageProvider>(context, listen: false).favoriteCards;

    final possibleCardAdditions = cardCreators.entries
        .where((e) => e.key.isVisible(session.faculties))
        .where((e) => !favorites.contains(e.key))
        .map((e) => Container(
              decoration: const BoxDecoration(),
              child: ListTile(
                title: Text(
                  e.value(Key(e.key.index.toString()), false, null).getTitle(),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  addCardToFavorites(e.key, context);
                  Navigator.pop(context);
                },
              ),
            ))
        .toList();

    return possibleCardAdditions.isEmpty
        ? [
            const Text(
                '''Todos os widgets disponíveis já foram adicionados à tua área pessoal!''')
          ]
        : possibleCardAdditions;
  }

  Widget createTopBar(
      BuildContext context, HomePageProvider editingModeProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PageTitle(
            name: DrawerItem.navPersonalArea.title, center: false, pad: false),
        GestureDetector(
            onTap: () => Provider.of<HomePageProvider>(context, listen: false)
                .setHomePageEditingMode(!editingModeProvider.isEditing),
            child: Text(
                editingModeProvider.isEditing ? 'Concluir Edição' : 'Editar',
                style: Theme.of(context).textTheme.bodySmall))
      ]),
    );
  }

  List<Widget> favoriteCardsFromTypes(List<FavoriteWidgetType> cardTypes,
      BuildContext context, HomePageProvider editingModeProvider) {
    final userSession =
        Provider.of<SessionProvider>(context, listen: false).session;
    return cardTypes
        .where((type) => type.isVisible(userSession.faculties))
        .where((type) => cardCreators.containsKey(type))
        .map((type) {
      final i = cardTypes.indexOf(type);
      return cardCreators[type]!(
          Key(i.toString()),
          editingModeProvider.isEditing,
          () => removeCardIndexFromFavorites(i, context));
    }).toList();
  }

  void reorderCard(int oldIndex, int newIndex,
      List<FavoriteWidgetType> favorites, BuildContext context) {
    final FavoriteWidgetType tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    saveFavoriteCards(context, favorites);
  }

  void removeCardIndexFromFavorites(int i, BuildContext context) {
    final List<FavoriteWidgetType> favorites =
        Provider.of<HomePageProvider>(context, listen: false).favoriteCards;
    favorites.removeAt(i);
    saveFavoriteCards(context, favorites);
  }

  void addCardToFavorites(FavoriteWidgetType type, BuildContext context) {
    final List<FavoriteWidgetType> favorites =
        Provider.of<HomePageProvider>(context, listen: false).favoriteCards;
    if (!favorites.contains(type)) {
      favorites.add(type);
    }
    saveFavoriteCards(context, favorites);
  }

  void saveFavoriteCards(
      BuildContext context, List<FavoriteWidgetType> favorites) {
    Provider.of<HomePageProvider>(context, listen: false)
        .setFavoriteCards(favorites);
    AppSharedPreferences.saveFavoriteCards(favorites);
  }
}
