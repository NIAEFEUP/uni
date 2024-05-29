import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/home/widgets/bus_stop_card.dart';
import 'package:uni/view/home/widgets/exam_card.dart';
import 'package:uni/view/home/widgets/exit_app_dialog.dart';
import 'package:uni/view/home/widgets/restaurant_card.dart';
import 'package:uni/view/home/widgets/schedule_card.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';
import 'package:uni/view/profile/widgets/account_info_card.dart';
import 'package:uni/view/profile/widgets/print_info_card.dart';

typedef CardCreator = GenericCard Function(
  Key key, {
  required bool editingMode,
  void Function()? onDelete,
});

class MainCardsList extends StatefulWidget {
  const MainCardsList(
    this.favoriteCardTypes,
    this.saveFavoriteCards, {
    super.key,
  });

  final List<FavoriteWidgetType> favoriteCardTypes;
  final void Function(List<FavoriteWidgetType>) saveFavoriteCards;

  static Map<FavoriteWidgetType, CardCreator> cardCreators = {
    FavoriteWidgetType.schedule: ScheduleCard.fromEditingInformation,
    FavoriteWidgetType.exams: ExamCard.fromEditingInformation,
    FavoriteWidgetType.account: AccountInfoCard.fromEditingInformation,
    FavoriteWidgetType.printBalance: PrintInfoCard.fromEditingInformation,
    FavoriteWidgetType.busStops: BusStopCard.fromEditingInformation,
    FavoriteWidgetType.restaurant: RestaurantCard.fromEditingInformation,
    FavoriteWidgetType.libraryOccupation:
        LibraryOccupationCard.fromEditingInformation,
  };

  @override
  State<StatefulWidget> createState() {
    return MainCardsListState();
  }
}

class MainCardsListState extends State<MainCardsList> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackButtonExitWrapper(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isEditing
              ? ReorderableListView(
                  onReorder: reorderCard,
                  header: createTopBar(context),
                  children: favoriteCardsFromTypes(
                    widget.favoriteCardTypes,
                    context,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    createTopBar(context),
                    ...favoriteCardsFromTypes(
                      widget.favoriteCardTypes,
                      context,
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: isEditing ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              S.of(context).widget_prompt,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: SizedBox(
              height: 200,
              width: 100,
              child: ListView(children: getCardAdders(context)),
            ),
            actions: [
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ), //Add FAB functionality here
      tooltip: S.of(context).add_widget,
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  List<Widget> getCardAdders(BuildContext context) {
    final session = Provider.of<SessionProvider>(context, listen: false).state!;

    final possibleCardAdditions = MainCardsList.cardCreators.entries
        .where((e) => e.key.isVisible(session.faculties))
        .where((e) => !widget.favoriteCardTypes.contains(e.key))
        .map(
          (e) => DecoratedBox(
            decoration: const BoxDecoration(),
            child: ListTile(
              title: Text(
                e
                    .value(Key(e.key.index.toString()), editingMode: false)
                    .getTitle(context),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                addCardToFavorites(e.key, context);
                Navigator.pop(context);
              },
            ),
          ),
        )
        .toList();

    return possibleCardAdditions.isEmpty
        ? [Text(S.of(context).all_widgets_added)]
        : possibleCardAdditions;
  }

  Widget createTopBar(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageTitle(
            name: S.of(context).nav_title('area'),
            center: false,
            pad: false,
          ),
          if (isEditing)
            ElevatedButton(
              onPressed: () => setState(() {
                isEditing = false;
              }),
              child: Text(
                S.of(context).edit_on,
              ),
            )
          else
            OutlinedButton(
              onPressed: () => setState(() {
                isEditing = true;
              }),
              child: Text(
                S.of(context).edit_off,
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> favoriteCardsFromTypes(
    List<FavoriteWidgetType> cardTypes,
    BuildContext context,
  ) {
    final userSession =
        Provider.of<SessionProvider>(context, listen: false).state;
    return cardTypes
        .where((type) => type.isVisible(userSession?.faculties ?? []))
        .where((type) => MainCardsList.cardCreators.containsKey(type))
        .map((type) {
      final i = cardTypes.indexOf(type);
      return MainCardsList.cardCreators[type]!(
        Key(i.toString()),
        editingMode: isEditing,
        onDelete: () => removeCardIndexFromFavorites(i, context),
      );
    }).toList();
  }

  void reorderCard(
    int oldIndex,
    int newIndex,
  ) {
    final newFavorites =
        List<FavoriteWidgetType>.from(widget.favoriteCardTypes);
    final tmp = newFavorites[oldIndex];
    newFavorites
      ..removeAt(oldIndex)
      ..insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    widget.saveFavoriteCards(newFavorites);
  }

  void removeCardIndexFromFavorites(int i, BuildContext context) {
    final favorites = List<FavoriteWidgetType>.from(widget.favoriteCardTypes)
      ..removeAt(i);
    widget.saveFavoriteCards(favorites);
  }

  void addCardToFavorites(FavoriteWidgetType type, BuildContext context) {
    final favorites = List<FavoriteWidgetType>.from(widget.favoriteCardTypes);
    if (!favorites.contains(type)) {
      favorites.add(type);
    }
    widget.saveFavoriteCards(favorites);
  }
}
