import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/exams/widgets/exam_filter_form.dart';

class ExamFilterMenu extends StatefulWidget {
  const ExamFilterMenu({super.key});

  @override
  ExamFilterMenuState createState() => ExamFilterMenuState();
}

class ExamFilterMenuState extends State<ExamFilterMenu> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_alt),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              final examProvider =
                  Provider.of<ExamProvider>(context, listen: false);
              final filteredExamsTypes = examProvider.filteredExamsTypes;
              return ChangeNotifierProvider.value(
                  value: examProvider,
                  child: ExamFilterForm(
                      Map<String, bool>.from(filteredExamsTypes),),);
            },);
      },
    );
  }
}
