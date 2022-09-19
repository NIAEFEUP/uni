import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

/// Tracks the state of Home page.
class HomePageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return MainCardsList();
  }
}
