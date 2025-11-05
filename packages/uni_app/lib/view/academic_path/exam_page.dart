import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/view/academic_path/widgets/exams_page_view.dart';
import 'package:uni/view/academic_path/widgets/no_exams_widget.dart';

class ExamsPage extends ConsumerStatefulWidget {
  const ExamsPage({super.key});

  @override
  ConsumerState<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends ConsumerState<ExamsPage> {
  List<String> hiddenExams = PreferencesController.getHiddenExams();
  Map<String, bool> filteredExamTypes =
      PreferencesController.getFilteredExams();

  @override
  Widget build(BuildContext context) {
    /*
      If we want to filters exams again
        filteredExamTypes[Exam.getExamTypeLong(exam.examType)] ??
     */
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: DefaultConsumer<List<Exam>>(
        provider: examProvider,
        builder: (context, ref, exams) {
          return ExamsPageView(
            exams: exams,
            hiddenExams: hiddenExams,
            onToggleHidden: (examId) {
              setState(() {
                if (hiddenExams.contains(examId)) {
                  hiddenExams.remove(examId);
                } else {
                  hiddenExams.add(examId);
                }
                PreferencesController.saveHiddenExams(hiddenExams);
              });
            },
          );
        },
        hasContent: (exams) => exams.isNotEmpty,
        nullContentWidget: LayoutBuilder(
          // Band-aid for allowing refresh on null content
          builder:
              (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: constraints.maxHeight, // Height of bottom navbar
                  padding: const EdgeInsets.only(bottom: 120),
                  child: const Center(child: NoExamsWidget()),
                ),
              ),
        ),
      ),
    );
  }
}
