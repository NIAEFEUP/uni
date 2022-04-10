import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/class_registration_view.dart';
import 'package:uni/view/Pages/schedule_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

class ClassRegistrationPage extends StatefulWidget {
  const ClassRegistrationPage({Key key}) : super(key: key);

  @override
  _ClassRegistrationState createState() => _ClassRegistrationState();
}

class _ClassRegistrationState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ClassRegistrationView();
  }
}
