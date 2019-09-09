import 'package:app_feup/view/Pages/GeneralPageView.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportPageView extends GeneralPageView {

  static final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> bugList = [];
  int _selectedBug = 0;

  @override
  Widget getBody(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    loadBugClassList();

    return new Column(
      children: <Widget>[
        new PageTitle(name: 'Bug report'),
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
            child: new Form(
              key: _formKey,
              child: new ListView(
                scrollDirection: Axis.vertical,
                children: getFormWidget(context)
              ),
            )
        )
      ]
    );
  }

  void loadBugClassList() {
    bugList = [];
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 1'),
      value: 0,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 2'),
      value: 1,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 3'),
      value: 2,
    ));
  }

  List<Widget> getFormWidget(BuildContext context) {
    List<Widget> formWidget = new List();

    formWidget.add(new Container(
      margin: EdgeInsets.only(bottom: 50),
      child: new Column(
        children: <Widget>[
          new Text(
              'Seleciona o tipo de bug',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.left,
          ),
          new DropdownButton(
            hint: new Text('Seleciona o tipo de bug'),
            items: bugList,
            value: _selectedBug,
            onChanged: (value) {
              _selectedBug = value;
            },
            isExpanded: true,
          )
        ],
      ),

    ));

    formWidget.add(new Container(
      //margin: EdgeInsets.all(0),
      child: new Column(
        children: <Widget>[
          new Text(
            'Descreve o bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new TextFormField(
            // margins
            minLines: 6,
            maxLines: 30,
            initialValue: "Descrição",
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              hintText: 'What do people call you?',
            ),
            validator: (value) {
              // TODO filter stuff to prevent attacks?
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          )
        ],
      ),

    ));

    return formWidget;
  }
}