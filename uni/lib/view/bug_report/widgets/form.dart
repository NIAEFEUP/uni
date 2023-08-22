import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/bug_report.dart';
import 'package:uni/view/bug_report/widgets/text_field.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class BugReportForm extends StatefulWidget {
  const BugReportForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return BugReportFormState();
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class BugReportFormState extends State<BugReportForm> {
  BugReportFormState() {
    loadBugClassList();
  }

  final String _gitHubPostUrl =
      'https://api.github.com/repos/NIAEFEUP/project-schrodinger/issues';
  final String _sentryLink =
      'https://sentry.io/organizations/niaefeup/issues/?query=';

  static final _formKey = GlobalKey<FormState>();

  final Map<int, Tuple2<String, String>> bugDescriptions = {
    0: const Tuple2<String, String>('Detalhe visual', 'Visual detail'),
    1: const Tuple2<String, String>('Erro', 'Error'),
    2: const Tuple2<String, String>('Sugestão de funcionalidade', 'Suggestion'),
    3: const Tuple2<String, String>(
      'Comportamento inesperado',
      'Unexpected behaviour',
    ),
    4: const Tuple2<String, String>('Outro', 'Other'),
  };
  List<DropdownMenuItem<int>> bugList = [];

  static int _selectedBug = 0;
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();
  static final TextEditingController emailController = TextEditingController();

  bool _isButtonTapped = false;
  bool _isConsentGiven = false;

  void loadBugClassList() {
    bugList = [];

    bugDescriptions.forEach(
      (int key, Tuple2<String, String> tup) =>
          {bugList.add(DropdownMenuItem(value: key, child: Text(tup.item1)))},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: getFormWidget(context)),
    );
  }

  List<Widget> getFormWidget(BuildContext context) {
    return [
      bugReportTitle(context),
      bugReportIntro(context),
      dropdownBugSelectWidget(context),
      FormTextField(
        titleController,
        Icons.title,
        maxLines: 2,
        description: 'Título',
        labelText: 'Breve identificação do problema',
        bottomMargin: 30,
      ),
      FormTextField(
        descriptionController,
        Icons.description,
        maxLines: 30,
        description: 'Descrição',
        labelText: 'Bug encontrado, como o reproduzir, etc',
        bottomMargin: 30,
      ),
      FormTextField(
        emailController,
        Icons.mail,
        maxLines: 2,
        description: 'Contacto (opcional)',
        labelText: 'Email em que desejas ser contactado',
        bottomMargin: 30,
        isOptional: true,
        formatValidator: (String? value) {
          return EmailValidator.validate(value ?? '')
              ? null
              : 'Por favor insere um email válido';
        },
      ),
      consentBox(context),
      submitButton(context)
    ];
  }

  /// Returns a widget for the title of the bug report form
  Widget bugReportTitle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          Icon(Icons.bug_report, size: 40),
          PageTitle(name: 'Bugs e Sugestões', center: false),
          Icon(Icons.bug_report, size: 40),
        ],
      ),
    );
  }

  /// Returns a widget for the overview text of the bug report form
  Widget bugReportIntro(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Text(
          '''Encontraste algum bug na aplicação?\nTens alguma '''
          '''sugestão para a app?\nConta-nos para que possamos melhorar!''',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Returns a widget for the dropdown displayed when the user tries to choose
  /// the type of bug on the form
  Widget dropdownBugSelectWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tipo de ocorrência',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: const Icon(
                  Icons.bug_report,
                ),
              ),
              Expanded(
                child: DropdownButton(
                  hint: const Text('Tipo de ocorrência'),
                  items: bugList,
                  value: _selectedBug,
                  onChanged: (value) {
                    setState(() {
                      _selectedBug = value! as int;
                    });
                  },
                  isExpanded: true,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget consentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: CheckboxListTile(
          title: Text(
            '''Consinto que esta informação seja revista pelo NIAEFEUP, podendo ser eliminada a meu pedido.''',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          value: _isConsentGiven,
          onChanged: (bool? newValue) {
            setState(() {
              _isConsentGiven = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: !_isConsentGiven
          ? null
          : () {
              if (_formKey.currentState!.validate() && !_isButtonTapped) {
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                submitBugReport();
              }
            },
      child: const Text(
        'Enviar',
        style: TextStyle(/*color: Colors.white*/ fontSize: 20),
      ),
    );
  }

  /// Submits the user's bug report
  ///
  /// If successful, an issue based on the bug
  /// report is created in the project repository.
  /// If unsuccessful, the user receives an error message.
  Future<void> submitBugReport() async {
    setState(() {
      _isButtonTapped = true;
    });
    final faculties = await AppSharedPreferences.getUserFaculties();
    final bugReport = BugReport(
      titleController.text,
      descriptionController.text,
      emailController.text,
      bugDescriptions[_selectedBug],
      faculties,
    ).toMap();
    String toastMsg;
    bool status;
    try {
      final sentryId = await submitSentryEvent(bugReport);
      final gitHubRequestStatus = await submitGitHubIssue(sentryId, bugReport);
      if (gitHubRequestStatus < 200 || gitHubRequestStatus > 400) {
        throw Exception('Network error');
      }
      Logger().i('Successfully submitted bug report.');
      toastMsg = 'Enviado com sucesso';
      status = true;
    } catch (e) {
      Logger().e('Error while posting bug report:$e');
      toastMsg = 'Ocorreu um erro no envio';
      status = false;
    }

    clearForm();

    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
      status
          ? await ToastMessage.success(context, toastMsg)
          : await ToastMessage.error(context, toastMsg);
      setState(() {
        _isButtonTapped = false;
      });
    }
  }

  Future<int> submitGitHubIssue(
    SentryId sentryEvent,
    Map<String, dynamic> bugReport,
  ) async {
    final description = '${bugReport['bugLabel']}\nFurther information on: '
        '$_sentryLink$sentryEvent';
    final data = {
      'title': bugReport['title'],
      'body': description,
      'labels': ['In-app bug report', bugReport['bugLabel']],
    };
    for (final faculty in bugReport['faculties'] as Iterable) {
      (data['labels'] as List).add(faculty);
    }
    return http
        .post(
      Uri.parse(_gitHubPostUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token ${dotenv.env["GH_TOKEN"]}}'
      },
      body: json.encode(data),
    )
        .then((http.Response response) {
      return response.statusCode;
    });
  }

  Future<SentryId> submitSentryEvent(Map<String, dynamic> bugReport) async {
    final description = bugReport['email'] == ''
        ? '${bugReport['text']} from ${bugReport['faculty']}'
        : '${bugReport['text']} from ${bugReport['faculty']}\nContact: '
            '${bugReport['email']}';
    return Sentry.captureMessage(
      '${bugReport['bugLabel']}: ${bugReport['text']}\n$description',
    );
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
}
