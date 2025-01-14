import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_files.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  static List<CourseUnitFileDirectory> data = [
    CourseUnitFileDirectory(
      'folder1',
      [
        CourseUnitFile('file1_2024-01-01.pdf', 'url1', 'code1'),
        CourseUnitFile('file2_2024-01-01.docx', 'url2', 'code2'),
        CourseUnitFile('file3_2024-01-01.ppt', 'url3', 'code3'),
      ],
    ),
    CourseUnitFileDirectory(
      'folder2',
      [
        CourseUnitFile('file4_2024-01-01.pdf', 'url4', 'code4'),
        CourseUnitFile('file5_2024-01-01.pdf', 'url5', 'code5'),
      ],
    ),
    CourseUnitFileDirectory(
      'Bloco de apontamentos I',
      [
        CourseUnitFile(
          'Diferenciação em R_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '547600',
        ),
        CourseUnitFile(
          'Integração em R_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '553479',
        ),
        CourseUnitFile(
          'Integrais impróprios_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '563094',
        ),
        CourseUnitFile(
          'Equações diferenciais ordinárias_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '563096',
        ),
        CourseUnitFile(
          'Transformada de Laplace_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '563097',
        ),
        CourseUnitFile(
          'Séries numéricas_2022-09-14.pdf',
          'https://sigarra.up.pt/feup/pt/conteudos_service.conteudos_cont',
          '567669',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CourseUnitFilesView(data);
  }
}
