import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';

class CourseUnitDetailPageView extends StatefulWidget {
  final CourseUnit courseUnit;

  const CourseUnitDetailPageView(this.courseUnit, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitDetailPageViewState();
  }
}

class CourseUnitDetailPageViewState
    extends UnnamedPageViewState<CourseUnitDetailPageView> {
  @override
  Widget getBody(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PageTitle(
        center: false,
        name: widget.courseUnit.name,
      ),
      Container(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ano letivo: ${widget.courseUnit.schoolYear}'),
            const SizedBox(
              height: 20,
            ),
            Text('Resultado: ${widget.courseUnit.grade}')
          ]))
    ]);
  }
}
