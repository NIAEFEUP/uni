import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_sheet_card.dart';

class CourseUnitSheetView extends StatelessWidget {
  final CourseUnitSheet courseUnitSheet;
  final String courseUnitName;

  const CourseUnitSheetView(this.courseUnitName, this.courseUnitSheet,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>().session;
    final baseUrl = Uri.parse(NetworkRouter.getBaseUrl(session.faculties[0]));

    final List<CourseUnitSheetCard> cards = [];
    for (var section in courseUnitSheet.sections.entries) {
      cards.add(_buildCard(section.key, section.value, baseUrl));
    }

    return Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(children: cards) //ListView(children: sections)),
            ));
  }

  CourseUnitSheetCard _buildCard(
      String sectionTitle, String sectionContent, Uri baseUrl) {
    return CourseUnitSheetCard(
        sectionTitle,
        HtmlWidget(
          sectionContent,
          renderMode: RenderMode.column,
          baseUrl: baseUrl,
          customWidgetBuilder: (element) {
            if (element.className == "informa" ||
                element.className == "limpar") {
              return Container();
            }
            if (element.localName == 'table') {
              try {
                element = _preprocessTable(element);
                final tBody = element.children
                    .firstWhere((element) => element.localName == 'tbody');
                final rows = tBody.children;
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Table(
                      border: TableBorder.all(),
                      children: rows
                          .map((e) => TableRow(
                              children: e.children
                                  .sublist(0, min(4, e.children.length))
                                  .map((e) => TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: HtmlWidget(
                                            e.outerHtml,
                                            renderMode: RenderMode.column,
                                            baseUrl: baseUrl,
                                          ))))
                                  .toList()))
                          .toList(),
                    ));
              } catch (e) {
                return null;
              }
            }
            return null;
          },
        ));
  }

  dom.Element _preprocessTable(dom.Element tableElement) {
    final processedTable = tableElement.clone(true);
    final tBody = tableElement.children
        .firstWhere((element) => element.localName == 'tbody');
    final rows = tBody.children;

    for (int i = 0; i < rows.length; i++) {
      for (int j = 0; j < rows[i].children.length; j++) {
        final cell = rows[i].children[j];
        if (cell.attributes['rowspan'] != null) {
          final rowSpan = int.parse(cell.attributes['rowspan']!);
          if (rowSpan <= 1) {
            continue;
          }
          processedTable.children[0].children[i].children[j].innerHtml = "";
          for (int k = 1; k < rowSpan; k++) {
            try {
              processedTable.children[0].children[i + k].children
                  .insert(j, cell.clone(true));
            } catch (_) {
              continue;
            }
          }
        }
      }
    }
    return processedTable;
  }
}
