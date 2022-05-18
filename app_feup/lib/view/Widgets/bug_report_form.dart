import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sentry/sentry.dart';
import 'package:uni/view/Widgets/form_text_field.dart';
import 'package:uni/view/Widgets/toast_message.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BugReportFormState();
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class BugReportFormState extends State<BugReportForm> {
  final String _gitHubPostUrl =
      'https://api.github.com/repos/NIAEFEUP/project-schrodinger/issues';
  final String _sentryLink =
      'https://sentry.io/organizations/niaefeup/issues/?query=';

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
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();
  static final TextEditingController emailController = TextEditingController();
  String ghToken = '';

  bool _isButtonTapped = false;
  bool _isConsentGiven = false;

  BugReportFormState() {
    if (ghToken == '') loadGHKey();
    loadBugClassList();
  }

  void loadBugClassList() {
    bugList = [];

    bugDescriptions.forEach((int key, Tuple2<String, String> tup) =>
        {bugList.add(DropdownMenuItem(child: Text(tup.item1), value: key))});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(bugReportTitle(context));
    formWidget.add(bugReportIntro(context));
    formWidget.add(dropdownBugSelectWidget(context));
    formWidget.add(FormTextField(
      titleController,
      Icons.title,
      minLines: 1,
      maxLines: 2,
      description: 'Título',
      labelText: 'Breve identificação do problema',
      bottomMargin: 30.0,
    ));

    formWidget.add(FormTextField(
      descriptionController,
      Icons.description,
      minLines: 1,
      maxLines: 30,
      description: 'Descrição',
      labelText: 'Bug encontrado, como o reproduzir, etc',
      bottomMargin: 30.0,
    ));

    formWidget.add(FormTextField(
      emailController,
      Icons.mail,
      minLines: 1,
      maxLines: 2,
      description: 'Contacto (opcional)',
      labelText: 'Email em que desejas ser contactado',
      bottomMargin: 30.0,
      isOptional: true,
      formatValidator: (value) {
        return EmailValidator.validate(value)
            ? null
            : 'Por favor insere um email válido';
      },
    ));

    formWidget.add(consentBox(context));

    formWidget.add(submitButton(context));

    return formWidget;
  }

  /// Returns a widget for the title of the bug report form
  Widget bugReportTitle(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(Icons.bug_report,
                color: Theme.of(context).accentColor, size: 50.0),
            Expanded(
                child: Text(
              'Bugs e Sugestões',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            Icon(Icons.bug_report,
                color: Theme.of(context).accentColor, size: 50.0),
          ],
        ));
  }

  /// Returns a widget for the overview text of the bug report form
  Widget bugReportIntro(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      padding: EdgeInsets.only(bottom: 20),
      child: Center(
        child: Text(
            '''Encontraste algum bug na aplicação?\nTens alguma sugestão para a app?\nConta-nos para que possamos melhorar!''',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center),
      ),
    );
  }

  /// Returns a widget for the dropdown displayed when the user tries to choose
  /// the type of bug on the form
  Widget dropdownBugSelectWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tipo de ocorrência',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.bug_report,
                  color: Theme.of(context).accentColor,
                )),
            Expanded(
                child: DropdownButton(
              hint: Text('Tipo de ocorrência'),
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

  Widget consentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      margin: EdgeInsets.only(bottom: 20, top: 0),
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(0),
        child: CheckboxListTile(
          activeColor: Theme.of(context).primaryColor,
          title: Text(
              '''Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido.''',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.left),
          value: _isConsentGiven,
          onChanged: (bool newValue) {
            setState(() {
              _isConsentGiven = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
        child: ElevatedButton(
      onPressed: !_isConsentGiven
          ? null
          : () {
              if (_formKey.currentState.validate() && !_isButtonTapped) {
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                submitBugReport();
              }
            },
      child: Text(
        'Enviar',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ));
  }

  /// Submits the user's bug report
  ///
  /// If successful, an issue based on the bug
  /// report is created in the project repository.
  /// If unsuccessful, the user receives an error message.
  void submitBugReport() async {
    setState(() {
      _isButtonTapped = true;
    });

    final String bugLabel = bugDescriptions[_selectedBug] == null
        ? 'Unidentified bug'
        : bugDescriptions[_selectedBug].item2;

    String toastMsg;
    try {
      final sentryId = await submitSentryEvent(bugLabel);
      final gitHubRequestStatus = await submitGitHubIssue(sentryId, bugLabel);
      if (gitHubRequestStatus < 200 || gitHubRequestStatus > 400) {
        throw Exception('Network error');
      }
      Logger().i('Successfully submitted bug report.');
      toastMsg = 'Enviado com sucesso';
    } catch (e) {
      Logger().e('Error while posting bug report:' + e.toString());
      toastMsg = 'Ocorreu um erro no envio';
    }

    clearForm();
    FocusScope.of(context).requestFocus(FocusNode());
    ToastMessage.display(context, toastMsg);

    setState(() {
      _isButtonTapped = false;
    });
  }

  Future<int> submitGitHubIssue(SentryId sentryEvent, String bugLabel) async {
    final String description = descriptionController.text +
        '\nFurther information on: ' +
        _sentryLink +
        sentryEvent.toString();
    final Map data = {
      'title': titleController.text,
      'body': description,
      'labels': ['In-app bug report', bugLabel],
    };
    return http
        .post(Uri.parse(_gitHubPostUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'token $ghToken'
            },
            body: json.encode(data))
        .then((http.Response response) {
      return response.statusCode;
    });
  }

  Future<SentryId> submitSentryEvent(String bugLabel) async {
    final String description = emailController.text == ''
        ? descriptionController.text
        : descriptionController.text + '\nContact: ' + emailController.text;
    return Sentry.captureMessage(
        bugLabel + ': ' + titleController.text + '\n' + description);
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    emailController.clear();

    if (!mounted) return;
    setState(() {
      _selectedBug = 0;
      _isConsentGiven = false;
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
