import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/sigarra_links_card.dart';


class UsefulLinksCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsefulLinksCardViewState();
}

/// Manages the 'Useful Links' section of the app.
class UsefulLinksCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return ListView(children: <Widget>[SigarraLinksCard()]);

  }
}