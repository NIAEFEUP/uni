import 'package:flutter/material.dart';
import 'package:app_feup/view/pages/SecondaryPageView.dart';

class MapPageView extends SecondaryPageView {

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Text("Mapa FEUP"),
    );
  }
}