import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/bug_report.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/bug_report/widgets/text_field.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/locale_notifier.dart';

class BugReportForm extends StatefulWidget {
  const BugReportForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return BugReportFormState();
  }
}

/// Manages the 'Bugs and Suggestions' section of the app
class BugReportFormState extends State<BugReportForm> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBugClassList();
  }

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
    final locale =
        Provider.of<LocaleNotifier>(context, listen: false).getLocale();

    bugList = bugDescriptions.entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(
              () {
                switch (locale) {
                  case AppLocale.pt:
                    return entry.value.item1;
                  case AppLocale.en:
                    return entry.value.item2;
                }
              }(),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          PageTitle(
            name: S.of(context).report_error_suggestion,
            pad: false,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          bugReportIntro(context),
          dropdownBugSelectWidget(context),
          FormTextField(
            titleController,
            Icons.title,
            maxLines: 2,
            description: S.of(context).title,
            labelText: S.of(context).problem_id,
            bottomMargin: 30,
          ),
          FormTextField(
            descriptionController,
            Icons.description,
            maxLines: 30,
            description: S.of(context).description,
            labelText: S.of(context).bug_description,
            bottomMargin: 30,
          ),
          FormTextField(
            emailController,
            Icons.mail,
            maxLines: 2,
            description: S.of(context).contact,
            labelText: S.of(context).desired_email,
            bottomMargin: 30,
            isOptional: true,
            formatValidator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }

              return EmailValidator.validate(value)
                  ? null
                  : S.of(context).valid_email;
            },
          ),
          consentBox(context),
          submitButton(context),
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
          S.of(context).bs_description,
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
            S.of(context).occurrence_type,
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
                  hint: Text(S.of(context).occurrence_type),
                  items: bugList,
                  value: _selectedBug,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedBug = value;
                      });
                    }
                  },
                  isExpanded: true,
                ),
              ),
            ],
          ),
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
            S.of(context).consent,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          value: _isConsentGiven,
          onChanged: (newValue) {
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
      child: Text(
        S.of(context).send,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  /// Submits the user's bug report
  ///
  /// If successful, an issue based on the bug
  /// report is created in the project repository.
  /// If unsuccessful, the user receives an error message.
  Future<void> submitBugReport() async {
    final s = S.of(context);

    setState(() {
      _isButtonTapped = true;
    });

    final session = Provider.of<SessionProvider>(context, listen: false).state;
    final faculties = session?.faculties ?? [];

    final bugReport = BugReport(
      titleController.text,
      descriptionController.text,
      emailController.text,
      bugDescriptions[_selectedBug],
      faculties,
    ).toJson();
    var toastMsg = '';
    bool status;
    try {
      await submitSentryEvent(bugReport);
      Logger().i('Successfully submitted bug report.');
      if (context.mounted) {
        toastMsg = s.success;
      }
      status = true;
    } catch (err, st) {
      await Sentry.captureException(err, stackTrace: st);
      Logger().e('Error while posting bug report:$err');
      if (context.mounted) {
        toastMsg = s.sent_error;
      }
      status = false;
    }

    clearForm();

    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
      status
          ? await ToastMessage.success(context, toastMsg)
          : await ToastMessage.error(context, toastMsg);
      if (context.mounted) {
        setState(() {
          _isButtonTapped = false;
        });
      }
    }
  }

  Future<void> submitSentryEvent(Map<String, dynamic> bugReport) async {
    final sentryId = await Sentry.captureMessage(
      'User Feedback',
      withScope: (scope) {
        scope
          ..setTag('report', 'true')
          ..setTag('report.type', bugReport['bugLabel'] as String);
      },
    );

    final userFeedback = SentryUserFeedback(
      eventId: sentryId,
      comments: '${bugReport['title']}\n ${bugReport['text']}',
      email: bugReport['email'] as String,
    );

    await Sentry.captureUserFeedback(userFeedback);
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    emailController.clear();

    if (!mounted) {
      return;
    }
    setState(() {
      _selectedBug = 0;
      _isConsentGiven = false;
    });
  }
}
