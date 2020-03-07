import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/view/theme.dart' as theme;
import 'package:toast/toast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return  BugReportFormState();
  }
}

class BugReportFormState extends State<BugReportForm> {
  final String _postUrl =
      'https://api.github.com/repos/NIAEFEUP/project-schrodinger/issues';
  final String _issueLabel = 'In-app bug report';

  static final _formKey = GlobalKey<FormState>();

  final Map<int, Tuple2<String, String>> bugDescriptions = {
    0: Tuple2<String, String>('Detalhe visual', 'Visual detail'),
    1: Tuple2<String, String>('Erro', 'Error'),
    2: Tuple2<String, String>('Sugestão de funcionalidade', 'Suggestion'),
    3: Tuple2<String, String>(
        'Comportamento inesperado', 'Unexpected behaviour'),
    4: Tuple2<String, String>('Outro', 'Other'),
  };
  List<DropdownMenuItem<int>> bugList = [];

  static int _selectedBug = 0;
  static final TextEditingController titleController =
       TextEditingController();
  static final TextEditingController descriptionController =
       TextEditingController();

  String ghToken = '';

  bool _isButtonTapped = false;

  BugReportFormState() {
    if (ghToken == '') loadGHKey();
    loadBugClassList();
  }

  void loadBugClassList() {
    bugList = [];

    bugDescriptions.forEach((int key, Tuple2<String, String> tup) => {
          bugList
              .add( DropdownMenuItem(child:  Text(tup.item1), value: key))
        });
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
        key: _formKey, child:  ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget =  List();

    formWidget.add(bugReportTitle(context));
    formWidget.add(bugReportIntro(context));
    formWidget.add(dropdownBugSelectWidget(context));
    formWidget.add( FormTextField(
      titleController,
      Icons.title,
      minLines: 1,
      maxLines: 2,
      description: 'Título',
      labelText: 'Breve identificação do problema',
      bottomMargin: 30.0,
    ));

    formWidget.add( FormTextField(
      descriptionController,
      Icons.description,
      minLines: 1,
      maxLines: 30,
      description: 'Descrição',
      labelText: 'Bug encontrado, como o reproduzir, etc',
      bottomMargin: 30.0,
    ));

    formWidget.add(submitButton(context));

    return formWidget;
  }

  Widget bugReportTitle(BuildContext context) {
    return  Container(
        alignment: Alignment.center,
        margin:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child:  Row(
          children: <Widget>[
            Icon(Icons.bug_report,
                color: Theme.of(context).primaryColor, size: 50.0),
            Expanded(
                child: Text(
              'Bugs e Sugestões',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            Icon(Icons.bug_report,
                color: Theme.of(context).primaryColor, size: 50.0),
          ],
        ));
  }

  Widget bugReportIntro(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      padding:  EdgeInsets.only(bottom: 20),
      child:  Center(
        child: Text(
            '''Encontraste algum Bug na aplicação?\nTens alguma
             sugestão para a app?\nConta-nos para que nós possamos melhorar!''',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget dropdownBugSelectWidget(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Text(
            'Seleciona o tipo de ocorrência',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
           Row(children: <Widget>[
             Container(
                margin:  EdgeInsets.only(right: 15),
                child:  Icon(
                  Icons.bug_report,
                  color: Theme.of(context).primaryColor,
                )),
            Expanded(
                child:  DropdownButton(
              hint:  Text('Seleciona o tipo de ocorrência'),
              items: bugList,
              value: _selectedBug,
              onChanged: (value) {
                setState(() {
                  _selectedBug = value;
                });
              },
              isExpanded: true,
            ))
          ])
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return  Container(
        child: RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      onPressed: () {
        if (_formKey.currentState.validate() && !_isButtonTapped) {
          submitBugReport();
        }
      },
      child: Text(
        'Enviar',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      color: Theme.of(context).primaryColor,
    ));
  }

  void submitBugReport() {
    setState(() {
      _isButtonTapped = true;
    });

    final String bugLabel = bugDescriptions[_selectedBug] == null
        ? 'Unidentified bug'
        : bugDescriptions[_selectedBug].item2;
    final Map data = {
      'title': titleController.text,
      'body': descriptionController.text,
      'labels': [_issueLabel, bugLabel]
    };

    http
        .post(_postUrl + '?access_token=' + ghToken,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data))
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      String msg;
      if (statusCode < 200 || statusCode > 400) {
        Logger().e('Error ' + statusCode.toString() + ' while posting bug');
        msg = 'Ocorreu um erro no envio';
      } else {
        Logger().i('Successfully submitted bug report.');
        msg = 'Enviado com sucesso';

        clearForm();

        Navigator.pop(context);
        setState(() {
          _isButtonTapped = false;
        });
      }
      

      FocusScope.of(context).requestFocus( FocusNode());
      displayBugToast(msg);
      setState(() {
        _isButtonTapped = false;
      });
    }).catchError((error) {
      Logger().e(error);
      FocusScope.of(context).requestFocus( FocusNode());

      final String msg =
          (error is SocketException) ? 'Falha de rede' : 'Ocorreu um erro';
      displayBugToast(msg);
      setState(() {
        _isButtonTapped = false;
      });
    });
  }

  void displayBugToast(String msg) {
    Toast.show(
      msg,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: theme.toastColor,
      backgroundRadius: 16.0,
      textColor: Colors.white,
    );
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();

    setState(() {
      _selectedBug = 0;
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void loadGHKey() async {
    final Map<String, dynamic> dataMap =
        await parseJsonFromAssets('assets/env/env.json');
    this.ghToken = dataMap['gh_token'];
  }
}
