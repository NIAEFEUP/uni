import 'dart:collection';
import 'dart:convert';
import 'package:app_feup/view/Widgets/BugPageTextWidget.dart';
import 'package:crypto/crypto.dart';
import 'package:toast/toast.dart';

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
      0 : "Detalhe visual",
      1 : "Erro",
      2 : "Sugestão",
      3 : "Comportamento inesperado",
    });
  }

  void loadBugClassList() {
    bugList = [];
    bugList.add(new DropdownMenuItem(
      child: new Text('Detalhe visual'),
      value: 0,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Erro'),
      value: 1,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Sugestão'),
      value: 2,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Comportamento inesperado'),
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

    formWidget.add(SubmitButton(context));

    return formWidget;
  }

  Widget DropdownBugSelectWidget(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
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
                  child: new Icon(Icons.bug_report, color: Theme.of(context).primaryColor,)
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

  Widget SubmitButton(BuildContext context) {

    String bugLabel = bugDescriptions[_selectedBug] == null ? "Unidentified bug" : bugDescriptions[_selectedBug];
    Map data = {
      "title": titleController.text,
      "body": descriptionController.text,
      "labels": ["bug report", bugLabel]
    };

    return new Container(
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

                String msg;
                MaterialColor statusColor;
                if (statusCode < 200 || statusCode > 400) {
                  print("Error " + statusCode.toString() + " while posting bug");

                  msg = "Ocorreu um erro no envio";
                  statusColor = Colors.red;
                }
                else {
                  print("Successfully submitted bug report.");

                  msg = "Enviado com sucesso";
                  statusColor = Colors.green;

                  clearForm();
                };

                FocusScope.of(context).requestFocus(new FocusNode());

                Toast.show(
                  msg,
                  context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM,
                  backgroundColor: statusColor,
                  backgroundRadius: 16.0,
                  textColor: Colors.white,
                );
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
        color: Theme.of(context).primaryColor,
      )
    );
  }

  String md5HashedDate() {
    return md5.convert(utf8.encode((new DateTime.now()).toString())).toString();
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();

    setState(() {
      _selectedBug = 0;
    });
  }

}