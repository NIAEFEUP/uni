import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/infodesk_card.dart';
import 'package:uni/view/Widgets/academic_services_card.dart';
import 'package:uni/view/Widgets/copy_center_card.dart';
import 'package:uni/view/Widgets/dona_bia_card.dart';
import 'package:uni/view/Widgets/multimedia_center_card.dart';
import 'package:url_launcher/url_launcher.dart';

Container h1(String text, BuildContext context, {bool initial = false}) {
  final double marginTop = initial ? 15.0 : 30.0;
  return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Opacity(
            opacity: 0.8,
            child: Text(text, style: Theme.of(context).textTheme.headline5)),
      ));
}

Container h2(String text, BuildContext context) {
  return Container(
      margin: const EdgeInsets.only(top: 13.0, bottom: 0.0, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.subtitle2),
      ));
}

Container infoText(String text, BuildContext context,
    {bool last = false, link = ''}) {
  final double marginBottom = last ? 8.0 : 0.0;
  return Container(
      margin: EdgeInsets.only(top: 8, bottom: marginBottom, left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .apply(color: Theme.of(context).colorScheme.tertiary),
            ),
            onTap: () => link != '' ? launchUrl(Uri.parse(link)) : null),
      ));
}

class UsefulContactsCardView extends StatefulWidget {
  const UsefulContactsCardView({super.key});

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
    list.add(const AcademicServicesCard());
    list.add(const InfoDeskCard());
    list.add(const DonaBiaCard());
    list.add(const CopyCenterCard());
    list.add(const MulimediaCenterCard());
    return list;
  }
}
