import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/main_cards_list.dart';


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
