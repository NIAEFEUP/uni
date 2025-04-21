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
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/bug_report/widgets/dropdown_bug_select.dart';
import 'package:uni/view/bug_report/widgets/text_field.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

class BugReportPageView extends StatefulWidget {
  const BugReportPageView({super.key});

  @override
  State<StatefulWidget> createState() => BugReportPageViewState();
}

/// Manages the 'Bugs and sugestions' section of the app.
class BugReportPageViewState extends SecondaryPageViewState<BugReportPageView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBugClassList();
  }

  @override
  void initState() {
    super.initState();
  }

  final Map<int, String> bugDescriptions = {
    0: 'bug_description_visual_detail',
    1: 'bug_description_error',
    2: 'bug_description_Suggestion',
    3: 'bug_description_unexpected_behaviour',
    4: 'bug_description_other',
  };

  List<DropdownMenuItem<int>> bugList = [];
  List<picker.XFile> pickedFiles = [];
  List<Widget> previewImages = [];

  static int _selectedBug = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isButtonTapped = false;
  bool _isConsentGiven = false;

  static final _formKey = GlobalKey<FormState>();

  // TODO (thePeras): This is weird, we should change
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
  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(bottom: 10)),
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: uploadImages,
                  label: Text(S.of(context).add_photo),
                ),
                Text(pickedFiles.length.toString()),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(1),
              child: Row(
                children: previewImages,
              ),
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
                      if (_formKey.currentState!.validate() &&
                          !_isButtonTapped) {
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
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    clearForm();
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navBugreport.route);

  Widget dropdownBugSelectWidget(BuildContext context) {
    return DropdownMenuBugSelect(
      items: bugList,
      selectedValue: _selectedBug,
      onChange: (newValue) {
        setState(() {
          _selectedBug = newValue ?? 0;
        });
      },
    );
  }

  Future<void> uploadImages() async {
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
            pickedFiles = selectedImages;
            while (pickedFiles.length > 3) {
              pickedFiles.removeAt(0);
            }
            final images = <Widget>[];
            for (var i = 0; i < pickedFiles.length; i++) {
              images.add(
                Padding(
                  padding: EdgeInsets.all(
                    8.0 / (pickedFiles.length > 3 ? pickedFiles.length / 3 : 1),
                  ),
                  child: SizedBox(
                    width: 100 /
                        (pickedFiles.length > 3 ? pickedFiles.length / 3 : 1),
                    child: Image.file(File(pickedFiles[i].path)),
                  ),
                ),
              );
            }
            previewImages = images;
          });
        }
      } catch (err) {
        if (mounted) {
          await ToastMessage.error(context, S.of(context).failed_upload);
        }
      }
    }
  }

  Future<void> submitBugReport() async {
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

    FocusScope.of(context).requestFocus(FocusNode());
    try {
      await submitSentryEvent(bugReport, pickedFiles);
      Logger().i('Successfully submitted bug report.');
      if (mounted) {
        await ToastMessage.success(context, S.of(context).success);
      }
    } catch (err, st) {
      await Sentry.captureException(err, stackTrace: st);
      Logger().e('Error while posting bug report:$err');
      if (mounted) {
        await ToastMessage.error(context, S.of(context).sent_error);
      }
    }

    clearForm();

    if (mounted) {
      setState(() {
        _isButtonTapped = false;
      });
    }
  }

  Future<void> submitSentryEvent(
    Map<String, dynamic> bugReport,
    List<picker.XFile> pickedFiles,
  ) async {
    final sentryId = await Sentry.captureMessage(
      'User Feedback',
      withScope: (scope) async {
        await scope.setTag('report', 'true');
        await scope.setTag('report.type', bugReport['bugLabel'] as String);
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
