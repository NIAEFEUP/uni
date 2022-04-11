import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/info_desk_card.dart';
import 'package:uni/view/Widgets/dona_bia_card.dart';
import 'package:uni/view/Widgets/copy_center_card.dart';
import 'package:uni/view/Widgets/multimedia_center_card.dart';

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
}

List<Widget> childrenList() {
  final List<Widget> list = [];
  list.add(InfoDeskCard());
  list.add(DonaBiaCard());
  list.add(CopyCenterCard());
  list.add(MulimediaCenterCard());
  return list;
}
