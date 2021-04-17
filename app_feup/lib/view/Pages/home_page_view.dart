import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/main_cards_list.dart';


class HomePageView extends StatefulWidget {
  final bool didTermsAndConditionChange;

  const HomePageView({Key key, this.didTermsAndConditionChange = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      HomePageViewState(didTermsAndConditionChange);
}

class HomePageViewState extends GeneralPageViewState {
  final bool didTermsAndConditionChange;

  HomePageViewState(this.didTermsAndConditionChange);

  @override
  Widget getBody(BuildContext context) {
    return MainCardsList(didTermsAndConditionChange);
  }
}
