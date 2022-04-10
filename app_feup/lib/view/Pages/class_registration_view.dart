import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

class ClassRegistrationPageView extends StatefulWidget {
  const ClassRegistrationPageView({Key key}) : super(key: key);

  @override
  _ClassRegistrationPageViewState createState() => _ClassRegistrationPageViewState();
}

class _ClassRegistrationPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Column(children: <Widget>[
      PageTitle(name: 'Escolha de Turmas'),
      SizedBox(height: 40),
      Container(
        margin: const EdgeInsets.only(left: 12),
        child: Text(
            'Esta funcionalidade é da autoria do grupo t4g12 da unidade curricular ES 2021/2022.'),
      ),
      SizedBox(height: 25),
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Isabel Vieira - up201907399'),
            Text('João Baltazar - up201905616'),
            Text('Nuno Costa - up201906272'),
            Text('Pedro Gonçalo Correia - up201905348'),
            Text('Pedro Silva - up201907523'),
          ],
        ),
      )
    ]);
  }
}
