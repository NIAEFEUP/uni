import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bug_report.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/bug_report/widgets/text_field.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:url_launcher/url_launcher.dart';

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

    bugList = bugD.entries
        .map(
          (entry) =>
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
        )
        .toList();
  }

  @override
  Widget getBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: <Widget>[
              // Header section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    S.of(context).feedback_type_title_section,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    S.of(context).feedback_type_description_section,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              GenericCard(
                tooltip: S.of(context).feedback_type_title_section,
                margin: EdgeInsets.zero,
                child: DropdownButton<int>(
                  underline: const SizedBox(),
                  isDense: true,
                  isExpanded: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  value: _selectedBug,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBug = newValue ?? 0;
                    });
                  },
                  items: bugList,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    S.of(context).description,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    S.of(context).feedback_description_section,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              FormTextField(
                titleController,
                maxLines: 3,
                hintText: S.of(context).problem_id,
                labelText: S.of(context).title,
              ),

              FormTextField(
                descriptionController,
                minLines: 3,
                maxLines: 5,
                hintText: S.of(context).bug_description,
                labelText: S.of(context).description,
              ),

              GenericCard(
                tooltip: S.of(context).feedback_images_title_section,
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).feedback_images_title_section,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        GestureDetector(
                          onTap: uploadImages,
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (previewImages.isEmpty)
                      Center(
                        child: Text(
                          S.of(context).feedback_images_empty_section,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    if (previewImages.isNotEmpty)
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: previewImages,
                      ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    S.of(context).feedback_privacy_section,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    S.of(context).feedback_privacy_description_section,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              FormTextField(
                emailController,
                maxLines: 2,
                description: S.of(context).contact,
                labelText: S.of(context).desired_email,
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

              GenericCard(
                tooltip: S.of(context).feedback_consent_title,
                margin: EdgeInsets.zero,
                child: CheckboxListTile(
                  value: _isConsentGiven,
                  onChanged: (newValue) {
                    setState(() {
                      _isConsentGiven = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: Theme.of(context).colorScheme.onSecondary,
                  checkColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  title: Text(
                    S.of(context).consent,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              GenericCard(
                tooltip: S.of(context).feedback_github_title_section,
                margin: EdgeInsets.zero,
                child: InkWell(
                  onTap: () async {
                    final uri = Uri.parse('https://github.com/NIAEFEUP/uni');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        UniIcon(
                          UniIcons.github,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).feedback_github_title_section,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                'github.com/NIAEFEUP/uni',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          size: 25,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: _isConsentGiven
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).disabledColor,
                    disabledBackgroundColor: Theme.of(context).disabledColor,
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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

    final bugReport = BugReport(
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
      previewImages.clear();
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
