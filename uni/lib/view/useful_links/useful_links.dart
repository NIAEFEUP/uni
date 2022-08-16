import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/useful_links/widgets/other_links_card.dart';
import 'package:uni/view/useful_links/widgets/sigarra_links_card.dart';

class UsefulLinksCardView extends StatefulWidget {
  const UsefulLinksCardView({super.key});

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
  list.add(const SigarraLinksCard());
  list.add(const OtherLinksCard());
  return list;
}
