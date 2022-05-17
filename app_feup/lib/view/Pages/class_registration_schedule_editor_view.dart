import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/class_registration_schedule_tile.dart';
import 'package:uni/view/Widgets/page_title.dart';

class ClassRegistrationScheduleEditorPageView extends StatefulWidget {
  final ScheduleOption scheduleOption;

  const ClassRegistrationScheduleEditorPageView(this.scheduleOption, {Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorPageViewState createState() =>
      _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption);
}

class _ClassRegistrationScheduleEditorPageViewState
    extends SecondaryPageViewState {
  final ScheduleOption scheduleOption;

  final viewKey = GlobalKey();

  _ClassRegistrationScheduleEditorPageViewState(this.scheduleOption) : super();

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, CourseUnitsForClassRegistration>(
      converter: (store) {
        // TODO get classes from appstate
        return CourseUnitsForClassRegistration(selected: [
          CourseUnit(
              name: 'Engenharia de Software',
              abbreviation: 'ES',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 2, 4, 'B115', 'ASL', '3LEIC01', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 1, 4, 'B343', 'FFC', '3LEIC02', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 1, 4, 'B206', 'AOR', '3LEIC03', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture('ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8,
                      30, 10, 30),
                  Lecture('ES', 'TP', 2, 4, 'B310', 'ASL', '3LEIC04', 10, 30,
                      12, 30),
                ]),
              ]),
          CourseUnit(
              name: 'Inteligência Artificial',
              abbreviation: 'IA',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 2, 4, 'B342', 'HCL', '3LEIC01', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 2, 4, 'B217', 'APR', '3LEIC02', 8, 30, 10,
                      30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 1, 4, 'B206', 'NRSG', '3LEIC03', 10, 30,
                      12, 30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture(
                      'IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
                  Lecture('IA', 'TP', 1, 4, 'B202', 'NRSG', '3LEIC04', 8, 30,
                      10, 30),
                ]),
              ]),
          CourseUnit(
              name: 'Computação Paralela e Distribuída',
              abbreviation: 'CPD',
              classes: [
                CourseUnitClass(name: '3LEIC01', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B342', 'PFS+JGB', '3LEIC01', 8,
                      30, 10, 30),
                ]),
                CourseUnitClass(name: '3LEIC02', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B343', 'SCS1', '3LEIC02', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC03', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 2, 4, 'B205', 'PMAADO', '3LEIC03', 8, 30,
                      10, 30),
                ]),
                CourseUnitClass(name: '3LEIC04', lectures: [
                  Lecture('CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14,
                      0, 16, 0),
                  Lecture('CPD', 'TP', 1, 4, 'B202', 'AJMC', '3LEIC04', 10, 30,
                      12, 30),
                ]),
              ]),
          CourseUnit(name: 'Compiladores', abbreviation: 'C', classes: [
            CourseUnitClass(name: '3LEIC01', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 1, 4, 'B342', 'AMSMF', '3LEIC01', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC02', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B217', 'LGBC', '3LEIC02', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC03', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B205', 'PMSP', '3LEIC03', 10, 30, 12, 30),
            ]),
            CourseUnitClass(name: '3LEIC04', lectures: [
              Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                  30, 12, 30),
              Lecture(
                  'C', 'TP', 2, 4, 'B310', 'PMSP', '3LEIC04', 8, 30, 10, 30),
            ]),
          ]),
        ]);
      },
      builder: (context, courseUnits) {
        return _ClassRegistrationScheduleEditorView(
            scheduleOption: this.scheduleOption,
            courseUnits: courseUnits,
            key: viewKey);
      },
    );
  }
}

class _ClassRegistrationScheduleEditorView extends StatefulWidget {
  final CourseUnitsForClassRegistration courseUnits;
  final ScheduleOption scheduleOption;

  const _ClassRegistrationScheduleEditorView(
      {this.scheduleOption, this.courseUnits, Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorViewState createState() =>
      _ClassRegistrationScheduleEditorViewState(
          this.scheduleOption, this.courseUnits);
}

class _ClassRegistrationScheduleEditorViewState
    extends State<_ClassRegistrationScheduleEditorView> {
  static const List<String> abbreviatedDayOfWeek = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sab',
    'Dom',
  ];

  final CourseUnitsForClassRegistration courseUnits;
  final ScheduleOption scheduleOption;
  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();
  
  TextEditingController _renameController;
  PageController _pageController;
  List<PageStorageKey<CourseUnit>> _expandableKeys;

  int _selectedDay = 0;

  _ClassRegistrationScheduleEditorViewState(
      this.scheduleOption, this.courseUnits) {
    _expandableKeys = [
      for (CourseUnit unit in courseUnits.selected) PageStorageKey(unit)
    ];
  }

  @override
  void initState() {
    super.initState();
    _renameController = TextEditingController(text: this.scheduleOption.name);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        buildScheduleEditor(context),
        buildScheduleDisplay(context),
      ],
    );
  }

  Widget buildScheduleEditor(BuildContext context) {
    return ListView(children: [
      PageTitle(name: 'Planeador de Horário'),
      SizedBox(height: 20),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onChanged: (text) {
                  scheduleOption.name = text;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.75)),
                  ),
                  labelText: 'Nome do horário',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
                controller: _renameController,
              ),
            ),
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.file_copy_outlined),
              onPressed: () => {/* TODO copy */},
            ),
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                db.deleteOption(scheduleOption);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      for (int i = 0; i < courseUnits.selected.length; i++)
        buildCourseDropdown(i, context),
      SizedBox(height: 20),
      Column(
        children: <Widget>[
          ElevatedButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () => db.saveSchedule(scheduleOption),
            child: Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    ]);
  }

  Widget buildScheduleDisplay(BuildContext context) {
    final List<Lecture> lectures = scheduleOption.
      getLectures(_selectedDay, courseUnits.selected);
    final List<bool> hasDiscontinuity =
        ScheduleOption.getDiscontinuities(lectures);
    final List<bool> hasCollision = ScheduleOption.getCollisions(lectures);

    int daysInWeek;
    if (scheduleOption.getLectures(6, courseUnits.selected).isNotEmpty) {
      daysInWeek = 7;
    } else if (scheduleOption.getLectures(5, courseUnits.selected).isNotEmpty) {
      daysInWeek = 6;
    } else {
      daysInWeek = 5;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: lectures.isEmpty
              ? Center(
                  child: Text('Não possui aulas ' +
                      [
                        'à Segunda-feira',
                        'à Terça-feira',
                        'à Quarta-feira',
                        'à Quinta-feira',
                        'à Sexta-feira',
                        'ao Sábado',
                        'ao Domingo'
                      ][_selectedDay] +
                      '.'))
              : ListView(
                  children: [
                    for (int i = 0; i < lectures.length; i++)
                      Container(
                        margin:
                            EdgeInsets.only(top: hasDiscontinuity[i] ? 70 : 0),
                        child: ClassRegistrationScheduleTile(
                          subject: lectures[i].subject,
                          typeClass: lectures[i].typeClass,
                          rooms: lectures[i].room,
                          begin: lectures[i].startTime,
                          end: lectures[i].endTime,
                          teacher: lectures[i].teacher,
                          classNumber: lectures[i].classNumber,
                          hasDiscontinuity: hasDiscontinuity[i],
                          hasCollision: hasCollision[i],
                        ),
                      ),
                  ],
                ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selectedDay,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedDay = index;
                      });
                    },
                    labelType: NavigationRailLabelType.none,
                    destinations: [
                      for (int day = 0;
                          day < daysInWeek;
                          day++)
                        NavigationRailDestination(
                          icon: getNavigationRailDestinationIcon(
                            context,
                            day,
                            scheduleOption
                                .hasCollisions(day, courseUnits.selected),
                            false,
                          ),
                          selectedIcon: getNavigationRailDestinationIcon(
                            context,
                            day,
                            scheduleOption
                                .hasCollisions(day, courseUnits.selected),
                            true,
                          ),
                          label: Placeholder(),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getNavigationRailDestinationIcon(
      BuildContext context, int day, bool hasCollision, bool isSelected) {
    TextStyle style = isSelected
        ? Theme.of(context).textTheme.headline1.apply(fontSizeDelta: -52)
        : TextStyle();

    if (hasCollision) {
      style = style.apply(color: Colors.red);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (hasCollision) Icon(Icons.warning, color: Colors.red),
        Text(
          abbreviatedDayOfWeek[day],
          style: style,
        ),
      ],
    );
  }

  Widget buildCourseDropdown(int index, BuildContext context) {
    final CourseUnit courseUnit = courseUnits.selected[index];
    final String selectedClass =
        scheduleOption.classesSelected[courseUnit.abbreviation];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ExpansionTile(
        key: _expandableKeys[index],
        title: Text(courseUnit.name),
        subtitle: selectedClass == null ? null : Text(selectedClass),
        children: <Widget>[
          for (CourseUnitClass courseUnitClass in courseUnit.classes)
            Container(
              // border
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.25),
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(courseUnitClass.name),
                      Column(children: [
                        for (Lecture lecture in courseUnitClass.lectures)
                          Text(lecture.typeClass,
                              style: TextStyle(fontSize: 10)),
                      ]),
                      Column(children: [
                        for (Lecture lecture in courseUnitClass.lectures)
                          Text(lecture.teacher, style: TextStyle(fontSize: 10)),
                      ]),
                      Column(children: [
                        for (Lecture lecture in courseUnitClass.lectures)
                          Text(abbreviatedDayOfWeek[lecture.day],
                              style: TextStyle(fontSize: 10)),
                      ]),
                      Column(children: [
                        for (Lecture lecture in courseUnitClass.lectures)
                          Text(lecture.startTime,
                              style: TextStyle(fontSize: 10)),
                      ]),
                    ],
                  ),
                  selected: courseUnitClass.name == selectedClass,
                  selectedTileColor: Theme.of(context).accentColor,
                  onTap: () {
                    setState(() {
                      scheduleOption.classesSelected[courseUnit.abbreviation] =
                          courseUnitClass.name;
                    });
                  }),
            ),
        ],
      ),
    );
  }
}
