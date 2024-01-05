import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/exams/widgets/exam_filter_form.dart';

class ExamPageTitle extends StatelessWidget {
  const ExamPageTitle(this.onDismissFilterDialog, {super.key});

  final void Function() onDismissFilterDialog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageTitle(
            name: S.of(context).nav_title(DrawerItem.navExams.title),
            center: false,
            pad: false,
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) {
                  final filteredExamsTypes =
                      PreferencesController.getFilteredExams();
                  return ExamFilterForm(
                    Map<String, bool>.from(filteredExamsTypes),
                    onDismissFilterDialog,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
