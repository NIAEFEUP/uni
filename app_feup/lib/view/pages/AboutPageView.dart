import 'package:flutter/material.dart';
import './GeneralPageView.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPageView extends GeneralPageView {

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child:
            SvgPicture.asset(
              'assets/images/ni_logo.svg',
              color: Theme.of(context).primaryColor,
              width: queryData.size.height/7,
              height: queryData.size.height/7,
            )
        ),
        Center(
            child: Padding(
                padding: EdgeInsets.only(
                    left: queryData.size.width/8,
                    right: queryData.size.width/8,
                    top: queryData.size.width/12,
                    bottom: queryData.size.width/12
                ),
                child : Text(
                  'Placeholder text',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                )
            )
        )
      ],
    );
  }
}