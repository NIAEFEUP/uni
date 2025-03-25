import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bug_report.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBugClassList();
  }

  @override
  void initState() {
    super.initState();
    print(pickedFiles.length);
  }

  static final _formKey = GlobalKey<FormState>();

  final Map<int, String> bugDescriptions = {
    0: 'bug_description_visual_detail',
    1: 'bug_description_error',
    2: 'bug_description_Suggestion',
    3: 'bug_description_unexpected_behaviour',
    4: 'bug_description_other',
  };
  List<DropdownMenuItem<int>> bugList = [];
  List<picker.XFile> pickedFiles = [];
  static int _selectedBug = 0;
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();
  static final TextEditingController emailController = TextEditingController();

  bool _isButtonTapped = false;
  bool _isConsentGiven = false;

  void loadBugClassList() {
    final bugD = {
      0: S.of(context).bug_description_visual_detail,
      1: S.of(context).bug_description_error,
      2: S.of(context).bug_description_Suggestion,
      3: S.of(context).bug_description_unexpected_behaviour,
      4: S.of(context).bug_description_other,
    };

    bugList = bugD.entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          PageTitle(
            name: S.of(context).leave_feedback,
            pad: false,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          bugReportIntro(context),
          dropdownBugSelectWidget(context),
          FormTextField(
            titleController,
            maxLines: 3,
            hintText: S.of(context).problem_id,
            labelText: S.of(context).title,
            bottomMargin: 20,
          ),
          FormTextField(
            emailController,
            maxLines: 2,
            description: S.of(context).contact,
            labelText: S.of(context).desired_email,
            bottomMargin: 20,
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
          FormTextField(
            descriptionController,
            maxLines: 3,
            hintText: S.of(context).description,
            labelText: S.of(context).bug_description,
            bottomMargin: 20,
          ),
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: pickImages,
                label: Text(S.of(context).add_photo),
              ),
              Text(pickedFiles.length.toString()),
            ],
          ),
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTileTheme(
              contentPadding: EdgeInsets.zero,
              child: RadioListTile(
                toggleable: true,
                value: true,
                title: Text(
                  S.of(context).consent,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.left,
                ),
                onChanged: (newValue) {
                  setState(() {
                    _isConsentGiven = !_isConsentGiven;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Theme.of(context).colorScheme.primary,
                groupValue: _isConsentGiven,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isConsentGiven
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor,
            ),
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
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: _isConsentGiven
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onTertiary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a widget for the overview text of the bug report form
  Widget bugReportIntro(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.only(bottom: 20),
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

  Future<void> unselect(int index) async {
    setState(() {
      pickedFiles.removeAt(index);
    });
  }

  Future<void> pickImages() async {
    final status = await Permission.photos.request();

    if (status.isPermanentlyDenied || status.isDenied) {
      await AppSettings.openAppSettings();
    } else {
      try {
        final imagePicker = picker.ImagePicker();
        final selectedImages = await imagePicker.pickMultiImage(
          limit: 2,
        );
        if (selectedImages.isNotEmpty) {
          setState(() {
            pickedFiles.addAll(selectedImages);
          });
        }
      } catch (err) {
        if (mounted) {
          await ToastMessage.error(context, S.of(context).failed_upload);
        }
      }
    }
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
      await submitSentryEvent(bugReport, pickedFiles);
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

  Future<void> submitSentryEvent(
      Map<String, dynamic> bugReport, List<picker.XFile> pickedFiles) async {
    final sentryId = await Sentry.captureMessage(
      'User Feedback',
      withScope: (scope) async {
        scope
          ..setTag('report', 'true')
          ..setTag('report.type', bugReport['bugLabel'] as String);
        for (final file in pickedFiles) {
          final fileBytes = await File(file.path).readAsBytes();
          scope.addAttachment(
            SentryAttachment.fromByteData(
              fileBytes.buffer.asByteData(),
              file.name,
            ),
          );
        }
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
      pickedFiles.clear();
      _selectedBug = 0;
      _isConsentGiven = false;
    });
  }


  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    super.dispose();
  }

}
