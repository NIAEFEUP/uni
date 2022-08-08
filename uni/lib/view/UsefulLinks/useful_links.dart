import 'package:flutter/material.dart';
import 'package:uni/view/Common/PagesLayouts/General/general.dart';
import 'package:uni/view/UsefulLinks/widgets/other_links_card.dart';
import 'package:uni/view/UsefulLinks/widgets/sigarra_links_card.dart';

class UsefulLinksCardView extends StatefulWidget {
  const UsefulLinksCardView({super.key});

  @override
  State<StatefulWidget> createState() => UsefulContactsCardViewState();
}

/// Manages the 'Useful Contacts' section of the app.
class UsefulContactsCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Column(children: [SigarraLinksCard(), OtherLinksCard()]);
  }
}
