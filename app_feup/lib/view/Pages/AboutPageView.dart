import 'package:flutter/material.dart';
import '../Pages/GeneralPageView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controller/load_static/TermsAndConditions.dart';

class AboutPageView extends GeneralPageView {

  @override
  Widget getBody(BuildContext context) {
    final Future<String> termsAndConditionsFuture = readTermsAndConditions();
    final MediaQueryData queryData = MediaQuery.of(context);
    return ListView(
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
                left: queryData.size.width/12,
                right: queryData.size.width/12,
                top: queryData.size.width/12,
                bottom: queryData.size.width/12
            ),
            child : 
              Column(
                children: <Widget>[
                  Text("App desenvolvida pelo NIAEFEUP. De estudantes, para estudantes.\n\n"),
                  FutureBuilder(
                    future: termsAndConditionsFuture,
                    builder: (BuildContext context, AsyncSnapshot<String> termsAndConditions) {
                      return Text(termsAndConditions.connectionState == ConnectionState.done ? termsAndConditions.data : "Carregando os Termos e Condições..."); 
                    }
                  )
                ]
              ),
            )
        )
      ],
    );
  }
}