import 'package:app_feup/view/Pages/GeneralPageView.dart';
import 'package:app_feup/view/Widgets/BugReportForm.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportPageView extends GeneralPageView {

  @override
  Widget getBody(BuildContext context) {
    return new ListView(
      children: <Widget>[
        BugReportTitle(),
        //new PageTitle(name: 'Bug report'),
        new Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: new Center(
            child: Text(
              "Encontraste algum Bug na aplicação?\nConta-nos sobre ele para que o possamos resolver!",
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center
            ),
          ),
        ),
        new Container(
            height: 500,//queryData.size.height,
            margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 50.0),
            child: new BugReportForm()
        )
      ]
    );
  }

  Widget BugReportTitle() {
    return new Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.symmetric(vertical: 20, horizontal: 70),
        child: new Row(
          children: <Widget>[
            Icon(
                Icons.bug_report,
                color: Colors.deepOrange,
                size: 50.0
            ),
            Expanded(
              child: Text(
                "Bug Report",
                textScaleFactor: 2,
                textAlign: TextAlign.center,
              )
            ),
            Icon(
                Icons.bug_report,
                color: Colors.deepOrange,
                size: 50.0
            ),
          ],
        )
    );
  }
}