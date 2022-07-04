import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';

class CalendarPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Text("Hello");
  }
}
