import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/common_widgets/page_title.dart';

class CourseUnitDetailPageView extends StatefulWidget {
  final CourseUnit courseUnit;

  const CourseUnitDetailPageView(this.courseUnit, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CourseUnitDetailPageViewState();
  }
}

class CourseUnitDetailPageViewState
    extends SecondaryPageViewState<CourseUnitDetailPageView> {
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
            Text(
                'Resultado: ${widget.courseUnit.grade == null || widget.courseUnit.grade!.isEmpty ? 'N/A' : widget.courseUnit.grade}')
          ]))
    ]);
  }
}
