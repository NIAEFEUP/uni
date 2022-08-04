import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/course_unit_card.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';

class CourseUnitsPageView extends StatefulWidget {
  const CourseUnitsPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitsPageViewState();
  }
}

class CourseUnitsPageViewState
    extends SecondaryPageViewState<CourseUnitsPageView> {
  @override
  Widget getBody(BuildContext context) {
    return Column(children: [
      const PageTitle(name: constants.navCourseUnits),
      StoreConnector<AppState, Tuple2<List<CourseUnit>?, RequestStatus?>>(
          converter: (store) => Tuple2(store.state.content['currUcs'],
              store.state.content['profileStatus']),
          builder: (context, ucsInfo) => RequestDependentWidgetBuilder(
              context: context,
              status: ucsInfo.item2 ?? RequestStatus.none,
              contentGenerator: generateCourseUnitsCards,
              content: ucsInfo.item1 ?? [],
              contentChecker: ucsInfo.item1?.isNotEmpty ?? false,
              onNullContent: Center(
                child: Text('Não existem cadeiras para apresentar',
                    style: Theme.of(context).textTheme.headline6),
              )))
    ]);
  }

  Widget generateCourseUnitsCards(courseUnits, context) {
    List<Widget> rows = [];
    for (var i = 0; i < courseUnits.length; i += 2) {
      if (i < courseUnits.length - 1) {
        rows.add(IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Flexible(
              child: CourseUnitCard(courseUnits[i].name, courseUnits[i].grade,
                  courseUnits[i].ects)),
          const SizedBox(width: 10),
          Flexible(
              child: CourseUnitCard(courseUnits[i + 1].name,
                  courseUnits[i + 1].grade, courseUnits[i + 1].ects)),
        ])));
      } else {
        rows.add(Row(children: [
          Flexible(
              child: CourseUnitCard(courseUnits[i].name, courseUnits[i].grade,
                  courseUnits[i].ects)),
          const SizedBox(width: 10),
          const Spacer()
        ]));
      }
    }

    return Column(children: <Widget>[
      Expanded(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: rows,
              )))
    ]);
  }
}
