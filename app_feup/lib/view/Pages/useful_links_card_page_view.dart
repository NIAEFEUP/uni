import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/sigarra_links_card.dart';
import 'package:uni/view/Widgets/other_links_card.dart';

class UsefulLinksCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsefulContactsCardViewState();
}

/// Manages the 'Useful Contacts' section of the app.
class UsefulContactsCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return ListView(children: childrenList(context));
  }
}

List<Widget> childrenList(BuildContext context) {
  final List<Widget> list = [];
  list.add(SigarraLinksCard());
  list.add(OtherLinksCard());
  return list;
}