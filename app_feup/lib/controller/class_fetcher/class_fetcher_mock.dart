import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/lecture.dart';

import 'class_fetcher.dart';

class ClassFetcherMock extends ClassFetcher {
  @override
  Future<List<CourseUnitClass>> getClasses(int occurrId) async {
    switch (occurrId) {
      case 484425: //ES
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 2, 4, 'B115', 'ASL', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 1, 4, 'B343', 'FFC', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 1, 4, 'B206', 'AOR', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'ES', 'T', 3, 4, 'B003', 'AMA+JPF', 'COMP_3315', 8, 30, 10, 30),
            Lecture('ES', 'TP', 2, 4, 'B310', 'ASL', '3LEIC04', 10, 30, 12, 30),
          ])
        ];
      case 484442: //IA
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 2, 4, 'B342', 'HCL', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 2, 4, 'B217', 'APR', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture(
                'IA', 'TP', 1, 4, 'B206', 'NRSG', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('IA', 'T', 0, 4, 'B002', 'LPR', 'COMP_2345', 9, 0, 11, 0),
            Lecture('IA', 'TP', 1, 4, 'B202', 'NRSG', '3LEIC04', 8, 30, 10, 30),
          ])
        ];
      case 484381: //CPD
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B342', 'PFS+JGB', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B343', 'SCS1', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 2, 4, 'B205', 'PMAADO', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'CPD', 'T', 3, 4, 'B020', 'JGB+PF', 'COMP_3112', 14, 0, 16, 0),
            Lecture(
                'CPD', 'TP', 1, 4, 'B202', 'AJMC', '3LEIC04', 10, 30, 12, 30),
          ])
        ];
      case 484379: //C
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture(
                'C', 'TP', 1, 4, 'B342', 'AMSMF', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture('C', 'TP', 2, 4, 'B217', 'LGBC', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture('C', 'TP', 2, 4, 'B205', 'PMSP', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('C', 'T', 3, 4, 'B013', 'DCC-AMSMF+PNF', 'COMP_3112', 10,
                30, 12, 30),
            Lecture('C', 'TP', 2, 4, 'B310', 'PMSP', '3LEIC04', 8, 30, 10, 30),
          ]),
        ];
      case 484431: //FSI
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 4, 4, 'B115', 'MMC', '3LEIC01', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture(
                'FSI', 'TP', 1, 4, 'B110', 'APM', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 2, 4, 'B115', 'RSM', '3LEIC03', 11, 0, 13, 0),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('FSI', 'T', 0, 2, 'EaD', 'MBB', 'COMP_169', 10, 0, 11, 0),
            Lecture('FSI', 'T', 3, 2, 'EaD', 'MBB', 'COMP_169', 9, 0, 10, 0),
            Lecture('FSI', 'TP', 2, 4, 'B217', 'MMC', '3LEIC04', 11, 0, 13, 0),
          ]),
        ];
      case 484433: //LBAW
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 1, 4, 'B308', 'tbs', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 2, 4, 'B305', 'SSN', '3LEIC02', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 1, 4, 'B302', 'tbs', '3LEIC03', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('LBAW', 'T', 0, 4, 'EaD', 'SSN', 'COMP_1396', 8, 0, 10, 0),
            Lecture(
                'LBAW', 'TP', 4, 4, 'B305', 'PMAB', '3LEIC04', 10, 30, 12, 30),
          ]),
        ];
      case 484430: //LTW
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 4, 4, 'B308', 'JPD', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 1, 4, 'B308', 'TNMFLD', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture(
                'LTW', 'TP', 1, 4, 'B102', 'JNVMS', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'LTW', 'T', 0, 2, 'EaD', 'JPVGL', 'COMP_1390', 12, 0, 13, 0),
            Lecture('LTW', 'T', 3, 2, 'EaD', 'JPVGL', 'COMP_1390', 8, 0, 9, 0),
            Lecture('LTW', 'TP', 4, 4, 'B305', 'MFF', '3LEIC04', 8, 30, 10, 30),
          ]),
        ];
      case 484434: //PFL
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 2, 4, 'B313', 'DCS', '3LEIC01', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 4, 4, 'B203', 'JPSFF', '3LEIC02', 8, 30, 10, 30),
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 4, 4, 'B107', 'JPSFF', '3LEIC03', 10, 30, 12, 30),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture('PFL', 'T', 0, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 30,
                12, 30),
            Lecture('PFL', 'T', 3, 2, 'EaD', 'AMSMF+DCS', 'COMP_1396', 10, 0,
                12, 0),
            Lecture(
                'PFL', 'TP', 1, 4, 'B101', 'GMLTL', '3LEIC04', 10, 30, 12, 30),
          ]),
        ];
      case 484435: //RC
        return [
          CourseUnitClass(name: '3LEIC01', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 1, 4, 'I320+I321', 'RLC', '3LEIC01', 16, 0, 18, 0),
          ]),
          CourseUnitClass(name: '3LEIC02', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 2, 4, 'I320+I321', 'SALC', '3LEIC02', 8, 30, 10, 30)
          ]),
          CourseUnitClass(name: '3LEIC03', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 4, 4, 'I320+I321', 'FBT', '3LEIC03', 14, 0, 16, 0),
          ]),
          CourseUnitClass(name: '3LEIC04', lectures: [
            Lecture(
                'RC', 'T', 3, 4, 'EaD', 'PMAB+MPR', 'COMP_1390', 11, 0, 13, 0),
            Lecture(
                'RC', 'TP', 4, 4, 'I320+I321', 'FBT', '3LEIC04', 16, 0, 18, 0),
          ]),
        ];
      default:
        return [];
    }
  }
}
