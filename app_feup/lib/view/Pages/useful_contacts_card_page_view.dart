import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/academic_services_card.dart';

class UsefulContactsCardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UsefulContactsCardViewState();
}

/// Manages the 'Useful Contacts' section of the app.
class UsefulContactsCardViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return ListView(children: <Widget>[AcademicServicesCard()]);
  }
}
