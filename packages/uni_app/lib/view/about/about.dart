import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class AboutPageView extends ConsumerStatefulWidget {
  const AboutPageView({super.key});

  @override
  ConsumerState<AboutPageView> createState() => AboutPageViewState();
}

/// Manages the 'about' section of the app.
class AboutPageViewState extends SecondaryPageViewState<AboutPageView> {
  @override
  Widget getBody(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: queryData.size.width / 12),
          child: SvgPicture.asset(
            'assets/images/logo_ni.svg',
            width: queryData.size.height / 7,
            height: queryData.size.height / 7,
          ),
        ),
        const Center(child: TermsAndConditions()),
      ],
    );
  }

  @override
  Future<void> onRefresh() async {}

  @override
  String? getTitle() {
    return null;
  }
}
