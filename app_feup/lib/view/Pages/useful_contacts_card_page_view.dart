import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/info_desk_card.dart';
import 'package:uni/view/Widgets/dona_bia_card.dart';
import 'package:uni/view/Widgets/copy_center_card.dart';
import 'package:uni/view/Widgets/multimedia_center_card.dart';

Container h1(String text, BuildContext context, {bool initial = false}) {
  final double marginTop = initial ? 15.0 : 30.0;
  return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: 0)),
      ));
}

Container h2(String text, BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4)),
      ));
}

Container infoText(String text, BuildContext context, {bool last = false}) {
  final double marginBottom = last ? 8.0 : 0.0;
  return Container(
      margin: EdgeInsets.only(top: 8, bottom: marginBottom, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ));
}

class UsefulContactsCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsefulContactsCardViewState();
}

/// Manages the 'Useful Contacts' section of the app.
class UsefulContactsCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ListView(children: childrenList());
  }
  
  List<Widget> childrenList() {
    final List<Widget> list = [];
    list.add(InfoDeskCard());
    list.add(DonaBiaCard());
    list.add(CopyCenterCard());
    list.add(MulimediaCenterCard());
    return list;
  }
}
