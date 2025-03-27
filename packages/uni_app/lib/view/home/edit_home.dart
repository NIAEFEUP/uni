import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/home/widgets/edit/draggable_square.dart';
import 'package:uni/view/home/widgets/edit/draggable_tile.dart';
import 'package:uni_ui/icons.dart';

class EditHomeView extends StatefulWidget {
  const EditHomeView({super.key});

  @override
  State<StatefulWidget> createState() => EditHomeViewState();
}

class EditHomeViewState extends State<EditHomeView> {
  List<DraggableTile> activeCards = [];
  List<DraggableSquare> listlessCards = [];

  (String, Icon) formatDraggableTile(FavoriteWidgetType favorite) {
    String title;
    Icon icon;

    switch (favorite.name) {
      case 'schedule':
        title = 'Schedule';
        icon = const UniIcon(UniIcons.lecture);
      case 'exams':
        title = 'Exams';
        icon = const UniIcon(UniIcons.exam);
      case 'library':
        title = 'Library';
        icon = const UniIcon(UniIcons.library);
      case 'restaurants':
        title = 'Restaurants';
        icon = const UniIcon(UniIcons.restaurant);
      case 'calendar':
        title = 'Calendar';
        icon = const UniIcon(UniIcons.calendar);
      case 'ucs':
        title = 'UCS';
        icon = const UniIcon(UniIcons.graduationCap);
      default:
        title = '';
        icon = const UniIcon(UniIcons.graduationCap);
    }
    return (title, icon);
  }

  void removeActiveWhileDragging(DraggableTile draggable) {
    setState(() {
      activeCards.remove(draggable);
    });
  }

  void removeListlessWhileDragging(DraggableSquare draggable) {
    setState(() {
      listlessCards.remove(draggable);
    });
  }

  @override
  void initState() {
    super.initState();

    const allCards = FavoriteWidgetType.values;
    final favoriteCards = PreferencesController.getFavoriteCards();

    activeCards = favoriteCards.map((favorite) {
      final data = formatDraggableTile(favorite);
      return DraggableTile(
        icon: data.$2,
        title: data.$1,
        callback: removeActiveWhileDragging,
      );
    }).toList();

    listlessCards =
        allCards.where((card) => !favoriteCards.contains(card)).map((favorite) {
      final data = formatDraggableTile(favorite);
      return DraggableSquare(
        icon: data.$2,
        title: data.$1,
        callback: removeListlessWhileDragging,
      );
    }).toList();
  }

  void saveCards() {
    PreferencesController.saveFavoriteCards(
      activeCards
          .map(
            (tile) => FavoriteWidgetType.values.firstWhere(
              (favorite) => favorite.name == tile.title.toLowerCase(),
            ),
          )
          .toList(),
    );
  }

  void addCard((String, Icon) card) {
    setState(() {
      activeCards.add(
        DraggableTile(
          icon: card.$2,
          title: card.$1,
          callback: removeActiveWhileDragging,
        ),
      );
    });

    saveCards();
  }

  void removeCard((String, Icon) card) {
    setState(() {
      listlessCards.add(
        DraggableSquare(
          icon: card.$2,
          title: card.$1,
          callback: removeListlessWhileDragging,
        ),
      );
    });

    saveCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: DragTarget<(String, Icon)>(
            builder: (context, candidate, rejected) {
              return SafeArea(
                child: Center(
                  child: Text(
                    'Drag and drop elements',
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
      body: DragTarget<(String, Icon)>(
        builder: (context, candidate, rejected) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView.separated(
              itemBuilder: (_, index) {
                if (index < activeCards.length) {
                  return activeCards[index];
                } else if (candidate.isNotEmpty) {
                  return ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 1,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.75),
                      ),
                      child: const ListTile(),
                    ),
                  );
                }
                return Container();
              },
              itemCount: activeCards.length + (candidate.isNotEmpty ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(
                height: 15,
              ),
            ),
          );
        },
        onAcceptWithDetails: (details) => addCard(details.data),
      ),
      bottomNavigationBar: DragTarget<(String, Icon)>(
        builder: (context, candidate, rejected) {
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
                  'Available elements',
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
                        ? [...listlessCards]
                        : [
                            ...listlessCards,
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
    );
  }
}
