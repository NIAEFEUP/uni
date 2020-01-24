import 'package:app_feup/view/Widgets/MainCardsList.dart';
import 'package:flutter/material.dart';
import '../Pages/GeneralPageView.dart';


class HomePageView extends GeneralPageView {

  @override
  Widget getBody(BuildContext context) {
    return MainCardsList();
  }

}


