import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';
import 'package:uni/view/lazy_consumer.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom:
          true, // Prevents the extendBody=true from creating a huge gap between each day's content
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<LectureProvider>().forceRefresh(context);
        },
        child: LazyConsumer<LectureProvider, List<Lecture>>(
          builder: (context, lectures) {
            return SchedulePageView(
              getMockLectures(), // Change to lectures
              now: now,
            );
          },
          hasContent: (lectures) => lectures.isNotEmpty,
          onNullContent: SchedulePageView(const [], now: now),
        ),
      ),
    );
  }
}

// Since there are no classes, we can use this to test the schedule page populated
List<Lecture> getMockLectures() {
  return [
    Lecture(
      'Fundamentos de Segurança Informática',
      'T',
      DateTime.now().subtract(const Duration(hours: 2)),
      DateTime.now().subtract(const Duration(hours: 1)),
      'B101',
      'Dr. Smith',
      'Class 1',
      1,
    ),
    Lecture(
      'Fundamentos de Segurança Informática',
      'TP',
      DateTime.now().add(Duration.zero),
      DateTime.now().add(const Duration(hours: 1)),
      'B102',
      'Dr. Johnson',
      'Class 2',
      2,
    ),
    Lecture(
      'Interação Pessoa Computador',
      'T',
      DateTime.now().add(const Duration(hours: 5)),
      DateTime.now().add(const Duration(hours: 4)),
      'B201',
      'Dr. Brown',
      'Class 3',
      3,
    ),
    Lecture(
      'Interação Pessoa Computador',
      'TP',
      DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      '103',
      'Dr. Taylor',
      'Class 4',
      4,
    ),
    Lecture(
      'Laboratório de Bases de Dados e Aplicações Web',
      'T',
      DateTime.now().add(const Duration(days: 3, hours: 4)),
      DateTime.now().add(const Duration(days: 3, hours: 5)),
      'B104',
      'Dr. Martinez',
      'Class 5',
      5,
    ),
    Lecture(
      'Programação Funcional e em Lógica',
      'TP',
      DateTime.now().add(const Duration(days: 1, hours: 5)),
      DateTime.now().add(const Duration(days: 1, hours: 6)),
      'B105',
      'Dr. Lee',
      'Class 6',
      6,
    ),
    Lecture(
      'Redes de Computadores',
      'TP',
      DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      DateTime.now().subtract(const Duration(days: 1)),
      'B106',
      'Dr. Williams',
      'Class 7',
      7,
    ),
    Lecture(
      'Redes de Computadores',
      'T',
      DateTime.now().add(const Duration(days: 1, hours: 7)),
      DateTime.now().add(const Duration(days: 1, hours: 8)),
      'B107',
      'Dr. Harris',
      'Class 8',
      8,
    ),
  ];
}
