import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:uni/model/class_registration_schedule_editor_model.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:uni/view/Pages/class_registration_schedule_editor_view.dart';
import 'package:uni/view/Widgets/section_card.dart';

class SchedulePlannerCard extends StatefulWidget {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final SchedulePreferenceList items;
  final Function(int oldIndex, int newIndex) onReorder;

  SchedulePlannerCard(
      {Key key, this.items, this.selectedCourseUnits, this.onReorder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchedulePlannerCardState(
      items: this.items,
      onReorder: this.onReorder,
      selectedCourseUnits: this.selectedCourseUnits,
    );
  }
}

class SchedulePlannerCardState extends State<SchedulePlannerCard> {
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final SchedulePreferenceList items;
  final Function(int oldIndex, int newIndex) onReorder;
  final double _itemHeight = 50.0;
  final double _borderRadius = 10.0;

  SchedulePlannerCardState(
      {this.items, this.selectedCourseUnits, this.onReorder});

  int getNextPreferenceValue() {
    final List<ScheduleOption> preferences = items.preferences;
    if (preferences.isEmpty) return 1;
    return preferences.last.preference + 1;
  }

  Future<void> updateList(
      BuildContext context, EditorAction action, int index) async {
    if (action == null) {
      setState(() {});
      return;
    }

    final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
    switch (action) {
      case EditorAction.delete:
        await db.deleteOption(items[index]);
        setState(() {
          items.remove(index);
        });
        break;
      case EditorAction.duplicate:
        final ScheduleOption copy =
            ScheduleOption.copy(null, items[index], items.length);

        final int copyIndex = items.length;
        setState(() {
          items.add(copy);
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassRegistrationScheduleEditorPageView(
                copy, selectedCourseUnits),
          ),
        ).then((action) => updateList(context, action, copyIndex));

        final int copyId = await db.createSchedule('', 0);
        copy.id = copyId;
        await db.saveSchedule(copy);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    int newScheduleID;
    return SectionCard(
      title: 'Planeamento de Horário',
      content: Column(
        children: [
          items.length == 0
              ? Text('Ainda não planeaste nenhum horário.')
              : Row(
                  children: [
                    buildPriorityItems(context),
                    buildScheduleItems(context, setState),
                  ],
                ),
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 32,
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.add_circle_outline_rounded),
              onPressed: () async {
                newScheduleID = await AppPlannedScheduleDatabase()
                    .createSchedule('Novo Horário', items.length);

                final ScheduleOption newOption = ScheduleOption.generate(
                    newScheduleID,
                    'Novo Horário',
                    {},
                    getNextPreferenceValue());
                final int index = items.length;
                this.items.add(newOption);
                final EditorAction action = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClassRegistrationScheduleEditorPageView(
                                newOption, selectedCourseUnits)));

                updateList(context, action, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPriorityItems(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 1.0,
          maxHeight: max(this._itemHeight * items.length, 1.0),
          minWidth: 1.0,
          maxWidth: 50.0,
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            for (int index = 0; index < items.length; index += 1)
              buildPriorityItem(index, context)
          ],
        ));
  }

  Widget buildPriorityItem(int index, BuildContext context) {
    return ConstrainedBox(
      key: Key('$index'),
      constraints: BoxConstraints(
        minHeight: this._itemHeight,
        maxHeight: this._itemHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).hintColor, shape: BoxShape.circle),
        child: Align(
          alignment: Alignment.center,
          child: Text((index + 1).toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .apply(fontSizeDelta: -55)),
        ),
      ),
    );
  }

  Widget buildScheduleItems(
      BuildContext context, void Function(void Function()) setState) {
    return Expanded(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1.0,
              maxHeight: max(this._itemHeight * items.length, 1.0),
            ),
            child: ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                for (int index = 0; index < items.length; index += 1)
                  buildScheduleItem(index, context, setState)
              ],
              onReorder: this.onReorder,
            )));
  }

  Widget buildScheduleItem(int index, BuildContext context,
      void Function(void Function()) setState) {
    return GestureDetector(
        key: Key('$index'),
        onTap: () async {
          final EditorAction action = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClassRegistrationScheduleEditorPageView(
                      items[index], selectedCourseUnits)));
          updateList(context, action, index);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: this._itemHeight,
            maxHeight: this._itemHeight,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(0x1c, 0, 0, 0),
                      blurRadius: 7.0,
                      offset: Offset(0.0, 1.0))
                ],
                color: Theme.of(context).hintColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(this._borderRadius))),
            child: Align(
              alignment: Alignment.center,
              child: Text(items[index].name,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
        ));
  }
}
