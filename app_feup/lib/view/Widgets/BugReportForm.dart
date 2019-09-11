import 'dart:collection';
import 'dart:convert';
import 'package:app_feup/view/Widgets/BugPageTextWidget.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BugReportFormState();
  }
}

/* TODO
Things to change:
 - bugDescriptions hashMap
 - bugClassList titles
 - descricoes e tooltips
 - access token api github
 - cores
 - margens e paddings
 - filter on validator?

 - prevent spam (apagar on submit, maybe prevent from submitting more)
 */
class BugReportFormState extends State<BugReportForm> {

  static final _formKey = GlobalKey<FormState>();

  HashMap<int, String> bugDescriptions = new HashMap();
  List<DropdownMenuItem<int>> bugList = [];

  int _selectedBug = 0;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  String postUrl = "https://api.github.com/repos/NIAEFEUP/project-schrodinger/issues";
  String ghToken = "";

  BugReportFormState() {
    initBugDescriptions();
    loadBugClassList();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new ListView(
          children: getFormWidget(context)
      )
    );
  }

  void initBugDescriptions() {
    bugDescriptions.clear();
    bugDescriptions.addAll({
      0 : "Bug 1",
      1 : "Bug 2",
      2 : "Bug 3",
      3 : "Bug 4",
    });
  }

  void loadBugClassList() {
    bugList = [];
    bugList.add(new DropdownMenuItem(
      child: new Text('Mosca'),
      value: 0,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Mosquito'),
      value: 1,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Escaravelho'),
      value: 2,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Aranha'),
      value: 3,
    ));
  }

  List<Widget> getFormWidget(BuildContext context) {
    List<Widget> formWidget = new List();

    formWidget.add(DropdownBugSelectWidget(context));
    formWidget.add(
        new BugPageTextWidget(
            titleController,
            Icons.title,
            minLines: 1,
            maxLines: 2,
            description:
            'Identifica o bug que encontraste',
            hintText: 'Identificação do bug encontrado',
            labelText: 'Título',
            bottomMargin: 30.0,
        )
    );

    formWidget.add(
        new BugPageTextWidget(
            descriptionController,
            Icons.description,
            minLines: 1,
            maxLines: 30,
            description:
            'Descreve o bug',
            hintText: 'Descrição do bug encontrado',
            labelText: 'Descrição',
            bottomMargin: 30.0,
        )
    );

    formWidget.add(SubmitButton());

    return formWidget;
  }

  Widget DropdownBugSelectWidget(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 40, top: 20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Seleciona o tipo de bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(right:15),
                  child: new Icon(Icons.bug_report)
                ),
                Expanded(
                    child: new DropdownButton(
                      hint: new Text('Seleciona o tipo de bug'),
                      items: bugList,
                      value: _selectedBug,
                      onChanged: (value) {
                        setState(() {
                          _selectedBug = value;
                        });
                      },
                      isExpanded: true,
                    )
                )
              ]
          )
        ],
      ),

    );
  }

  Widget SubmitButton() {

    String bugLabel = bugDescriptions[_selectedBug] == null ? "Unidentified bug" : bugDescriptions[_selectedBug];
    Map data = {
      "title": titleController.text + " - " + md5HashedDate().substring(0, 11),
      "body": descriptionController.text,
      "labels": ["bug report", bugLabel]
    };

    print(data["title"]);
    print(data["body"]);

    return new Container(
      //margin: new EdgeInsets.only(top: 50),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),

        onPressed: () {
          if (_formKey.currentState.validate()) {
            http.post(
                postUrl + "?access_token=" + ghToken,
                headers: {
                  "Content-Type" : "application/json"
                },
                body: json.encode(data)
              ).then((http.Response response) {
                final int statusCode = response.statusCode;

                if (statusCode < 200 || statusCode > 400) {
                  print("Error " + statusCode.toString() + " while posting bug");
                }
                else {
                  print("Successfully submitted bug report.");
                };
            });
          }
        },

        child: Text(
          'Enviar',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
          ),
        ),
        color: Colors.deepOrange,
      )
    );
  }

  String md5HashedDate() {
    return md5.convert(utf8.encode((new DateTime.now()).toString())).toString();
  }

}