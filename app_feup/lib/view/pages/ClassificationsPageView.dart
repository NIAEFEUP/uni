import 'package:flutter/material.dart';
import 'package:app_feup/view/pages/SecondaryPageView.dart';

class ClassificationsPageView extends  SecondaryPageView{

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Text("Classificações"),
    );
  }
}