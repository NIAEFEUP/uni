import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets/edit/draggable_square.dart';
import 'package:uni/view/home/widgets/edit/draggable_tile.dart';

class EditHomeView extends StatefulWidget {
  const EditHomeView({super.key});

  @override
  State<StatefulWidget> createState() => EditHomeViewState();
}

class EditHomeViewState extends State<EditHomeView> {
  List<FavoriteWidgetType> activeCards = [];
  List<FavoriteWidgetType> listlessCards = [];

  void removeActiveWhileDragging(FavoriteWidgetType widgetType) {
    setState(() {
      activeCards.remove(widgetType);
    });
  }

  void removeListlessWhileDragging(FavoriteWidgetType widgetType) {
    setState(() {
      listlessCards.remove(widgetType);
    });
  }

  @override
  void initState() {
    super.initState();

    const allCards = FavoriteWidgetType.values;
    final favoriteCards = PreferencesController.getFavoriteCards();

    activeCards = favoriteCards;

    listlessCards = allCards
        .where((widgetType) => !favoriteCards.contains(widgetType))
        .toList();
  }

  void saveCards() {
    PreferencesController.saveFavoriteCards(activeCards);
  }

  void addCard(FavoriteWidgetType widgetType) {
    setState(() {
      activeCards.add(
        widgetType,
      );
    });

    saveCards();
  }

  void removeCard(FavoriteWidgetType widgetType) {
    setState(() {
      listlessCards.add(widgetType);
    });

    saveCards();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: Container(
            height: 90,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFF280709),
                  Color(0xFF511515),
                ],
                center: Alignment.topLeft,
                radius: 1.5,
                stops: [0, 1],
              ),
            ),
            child: DragTarget<FavoriteWidgetType>(
              builder: (context, candidate, rejected) {
                return SafeArea(
                  child: Center(
                    child: Text(
                      S.of(context).drag_and_drop,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge, // titleMedium as in figma is with the wrong colors
                    ),
                  ),
                );
              },
              onAcceptWithDetails: (details) => removeCard(details.data),
            ),
          ),
        ),
        body: DragTarget<FavoriteWidgetType>(
          builder: (context, candidate, rejected) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListView.builder(
                itemCount: activeCards.length * 2 + 1,
                itemBuilder: (context, index) {
                  if (index.isEven) {
                    final dropIndex = (index / 2).floor();
                    return DragTarget<FavoriteWidgetType>(
                      builder: (context, candidate, rejected) => Container(
                        height: 20,
                        margin: const EdgeInsets.only(top: 2, bottom: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: candidate.isNotEmpty
                              ? Theme.of(context).shadowColor.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                      ),
                      onAcceptWithDetails: (details) {
                        setState(() {
                          activeCards
                            ..remove(details.data)
                            ..insert(
                              dropIndex,
                              details.data,
                            );
                          saveCards();
                        });
                      },
                    );
                  } else {
                    final cardIndex = ((index - 1) / 2).floor();
                    return DraggableTile(
                      data: activeCards[cardIndex],
                      callback: removeActiveWhileDragging,
                    );
                  }
                },
              ),
            );
          },
          onAcceptWithDetails: (details) => addCard(details.data),
        ),
        bottomNavigationBar: DragTarget<FavoriteWidgetType>(
          builder: (context, candidate, rejected) {
            final listlessCardWidgets = listlessCards
                .map(
                  (widgetType) => DraggableSquare(
                    data: widgetType,
                    callback: removeListlessWhileDragging,
                  ),
                )
                .toList();

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 35),
              height: 350,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF280709),
                    Color(0xFF511515),
                  ],
                  center: Alignment.topLeft,
                  radius: 1.5,
                  stops: [0, 1],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).available_elements,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // TODO: titleMedium not working
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 10,
                      children: candidate.isEmpty
                          ? listlessCardWidgets
                          : [
                              ...listlessCardWidgets,
                              ClipSmoothRect(
                                radius: SmoothBorderRadius(
                                  cornerRadius: 15,
                                  cornerSmoothing: 1,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.25),
                                  ),
                                  width: 75,
                                  height: 75,
                                ),
                              ),
                            ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                      '/${NavigationItem.navPersonalArea.route}',
                      (route) => false,
                    ),
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            );
          },
          onAcceptWithDetails: (details) => removeCard(details.data),
        ),
      ),
    );
  }
}
