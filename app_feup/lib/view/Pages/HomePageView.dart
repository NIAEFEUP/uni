import 'package:uni/view/Widgets/MainCardsList.dart';
import 'package:flutter/material.dart';
import '../Pages/GeneralPageView.dart';


class HomePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageViewState();
}
class HomePageViewState extends GeneralPageViewState {

  @override
  Widget getBody(BuildContext context) {
    return MainCardsList();
  }

}


