import 'package:uni/controller/local_storage/app_planned_schedules_database.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/class_registration_schedule_tile.dart';
import 'package:uni/view/Widgets/page_title.dart';

class ClassRegistrationScheduleEditorPageView extends StatefulWidget {
  final ScheduleOption scheduleOption;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final SchedulePreferenceList options;


  const ClassRegistrationScheduleEditorPageView(
      this.scheduleOption,
      this.selectedCourseUnits,
      this.options,
      {Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorPageViewState createState() =>
      _ClassRegistrationScheduleEditorPageViewState(
          this.scheduleOption,
          this.selectedCourseUnits,
          this.options
      );

}

class _ClassRegistrationScheduleEditorPageViewState
    extends SecondaryPageViewState {
  final ScheduleOption scheduleOption;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final SchedulePreferenceList options;

  final viewKey = GlobalKey();

  _ClassRegistrationScheduleEditorPageViewState(
      this.scheduleOption,
      this.selectedCourseUnits,
      this.options)
      : super();

  @override
  Widget getBody(BuildContext context) {
    return _ClassRegistrationScheduleEditorView(
      scheduleOption: scheduleOption,
      selectedCourseUnits: selectedCourseUnits,
      key: viewKey,
    );
  }
}

class _ClassRegistrationScheduleEditorView extends StatefulWidget {
  final ScheduleOption scheduleOption;
  final CourseUnitsForClassRegistration selectedCourseUnits;
  final SchedulePreferenceList options;

  const _ClassRegistrationScheduleEditorView(
      {this.scheduleOption, this.selectedCourseUnits, this.options, Key key})
      : super(key: key);

  @override
  _ClassRegistrationScheduleEditorViewState createState() =>
      _ClassRegistrationScheduleEditorViewState(
          this.scheduleOption,
          this.selectedCourseUnits,
          this.options);
}

class _ClassRegistrationScheduleEditorViewState
    extends State<_ClassRegistrationScheduleEditorView> {
  final ScheduleOption scheduleOption;
  final CourseUnitsForClassRegistration courseUnits;
  final SchedulePreferenceList options;

  static const List<String> abbreviatedDayOfWeek = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sab',
    'Dom',
  ];

  final AppPlannedScheduleDatabase db = AppPlannedScheduleDatabase();

  TextEditingController _renameController;
  PageController _pageController;
  List<PageStorageKey<CourseUnit>> _expandableKeys;

  int _selectedDay = 0;

  _ClassRegistrationScheduleEditorViewState(
      this.scheduleOption, this.courseUnits, this.options) {
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
              onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(

                              builder: (context) {
                                final ScheduleOption copy =
                                ScheduleOption.copy(
                                    scheduleOption,
                                    options.preferences.length);
                                options.preferences.add(copy);
                                return ClassRegistrationScheduleEditorPageView(
                                    copy,
                                    courseUnits,
                                    options
                                );
                              }
                        )
                );
                    },
            ),
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.delete_outline),
              onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Apagar horário'),
                          content: const Text(
                              'Tem a certeza que pretende apagar o horário?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                db.deleteOption(scheduleOption);
                                options.preferences.remove(scheduleOption);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Apagar'),
                            ),
                          ],
                        ),
                      ),
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
            onPressed: () async {
              Navigator.pop(context);
              await db.saveSchedule(scheduleOption);
            },
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
    final List<Lecture> lectures =
        scheduleOption.getLectures(_selectedDay, courseUnits.selected);
    final List<bool> hasDiscontinuity = Lecture.getDiscontinuities(lectures);
    final List<bool> hasCollision = Lecture.getCollisions(lectures);

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
                      for (int day = 0; day < daysInWeek; day++)
                        NavigationRailDestination(
                          icon: getNavigationRailDestinationIcon(
                            context,
                            day,
                            scheduleOption.hasCollisions(
                                day, courseUnits.selected),
                            false,
                          ),
                          selectedIcon: getNavigationRailDestinationIcon(
                            context,
                            day,
                            scheduleOption.hasCollisions(
                                day, courseUnits.selected),
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
