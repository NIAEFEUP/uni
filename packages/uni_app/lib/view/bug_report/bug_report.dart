import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bug_report.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/bug_report/widgets/dropdown_bug_select.dart';
import 'package:uni/view/bug_report/widgets/text_field.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/theme.dart';

class BugReportPageView extends ConsumerStatefulWidget {
  const BugReportPageView({super.key});

  @override
  ConsumerState<BugReportPageView> createState() => BugReportPageViewState();
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

  final bugDescriptions = <int, String>{
    0: 'bug_description_visual_detail',
    1: 'bug_description_error',
    2: 'bug_description_Suggestion',
    3: 'bug_description_unexpected_behaviour',
    4: 'bug_description_other',
  };

  List<DropdownMenuItem<int>> bugList = [];
  List<XFile> pickedFiles = [];
  List<Widget> previewImages = [];

  static var _selectedBug = 0;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();

  var _isButtonTapped = false;
  var _isConsentGiven = false;

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

    bugList =
        bugD.entries
            .map(
              (entry) =>
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
            )
            .toList();
  }

  @override
  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: Icon(
                    Icons.add, // use uni_ui icon instead
                    color: Theme.of(context).primaryVibrant,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondary,
                  ),
                  onPressed: uploadImages,
                  label: Text(S.of(context).add_photo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(1),
                child: Row(children: previewImages),
              ),
              Container(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.only(bottom: 20),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _isConsentGiven,
                    onChanged: (newValue) {
                      setState(() {
                        _isConsentGiven = newValue ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Theme.of(context).primaryVibrant,
                    title: Text(
                      S.of(context).consent,
                      style: Theme.of(context).bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isConsentGiven
                          ? Theme.of(context).primaryVibrant
                          : Theme.of(context).divider,
                ),
                onPressed:
                    !_isConsentGiven
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
                  style: Theme.of(context).titleLarge!.copyWith(
                    color:
                        _isConsentGiven
                            ? Theme.of(context).background
                            : Theme.of(context).background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onRefresh() async {
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
    try {
      final picker = ImagePicker();
      final files = await picker.pickMultiImage();
      if (files.isNotEmpty) {
        pickedFiles = files;
        previewImages = await Future.wait(
          files.map((file) async {
            final bytes = await file.readAsBytes();
            return Padding(
              padding: EdgeInsets.all(
                8.0 / (files.length > 3 ? files.length / 3 : 1),
              ),
              child: SizedBox(
                width: 80 / (files.length > 3 ? files.length / 3 : 1),
                child: Image.memory(bytes, height: 120, fit: BoxFit.cover),
              ),
            );
          }).toList(),
        );
        setState(() {});
      }
    } catch (err) {
      if (mounted) {
        await ToastMessage.error(context, S.of(context).failed_upload);
      }
    }
  }

  Future<void> submitBugReport() async {
    setState(() {
      _isButtonTapped = true;
    });

    final session = await ref.watch(sessionProvider.future);
    final faculties = session?.faculties ?? [];

    final bugReport =
        BugReport(
          titleController.text,
          descriptionController.text,
          emailController.text,
          bugDescriptions[_selectedBug],
          faculties,
        ).toJson();

    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
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
    List<XFile> pickedFiles,
  ) async {
    final sentryId = await Sentry.captureMessage(
      'User Feedback',
      withScope: (scope) async {
        await scope.setTag('report', 'true');
        await scope.setTag('report.type', bugReport['bugLabel'] as String);

        for (final file in pickedFiles) {
          final bytes = await file.readAsBytes();
          scope.addAttachment(
            SentryAttachment.fromUint8List(
              bytes,
              file.name,
              contentType: file.mimeType,
            ),
          );
        }
      },
    );

    final userFeedback = SentryFeedback(
      associatedEventId: sentryId,
      message: '${bugReport['title']}\n ${bugReport['text']}',
      contactEmail: bugReport['email'] as String,
    );

    await Sentry.captureFeedback(userFeedback);
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
