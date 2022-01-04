import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

class CantinePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CantinePageViewState();
}

class CantinePageViewState extends SecondaryPageViewState {

  @override
  Widget getBody(BuildContext context) {
    return  Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
    );
  }
}