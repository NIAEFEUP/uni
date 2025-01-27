import 'package:flutter/material.dart';
import 'package:uni/view/home/widgets2/edit/draggable_square.dart';
import 'package:uni/view/home/widgets2/edit/draggable_tile.dart';

class EditHome extends StatelessWidget {
  EditHome({super.key});

  final List<DraggableTile> activeCards = [
    const DraggableTile(icon: Icon(Icons.schedule), title: 'Schedule'),
    const DraggableTile(icon: Icon(Icons.map), title: 'Map'),
  ];
  final List<DraggableSquare> listlessCards = [
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
    const DraggableSquare(
      icon: Icon(
        Icons.calendar_month,
        size: 32,
      ),
      title: 'Calendar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125),
        child: Container(
          height: 125,
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
          child: SafeArea(
            child: Center(
              child: Text(
                'Drag and drop elements',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge, // titleMedium as in figma is with the wrong colors
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListView.separated(
          itemBuilder: (_, index) => activeCards[index],
          itemCount: activeCards.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: 20,
          ),
        ),
      ),
      bottomSheet: Container(
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
                children: [...listlessCards],
              ),
            ),
            Text(
              'Cancel | Edit',
              style: Theme.of(context).textTheme.titleLarge,
            ), // TODO: change
          ],
        ),
      ),
    );
  }
}
