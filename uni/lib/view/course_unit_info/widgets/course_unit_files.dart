import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:uni/view/course_unit_info/widgets/course_unit_info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseUnitFilesView extends StatelessWidget {
  const CourseUnitFilesView(this.files, {Key? key}) : super(key: key);
  final List<CourseUnitFile> files;

  @override
  Widget build(BuildContext context) {
    final cards = files.map((file) => _buildCard(file)).toList();

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView(children: cards),
    );
  }

  CourseUnitInfoCard _buildCard(CourseUnitFile file) {
    return CourseUnitInfoCard(
      file.name,
      GestureDetector(
        onTap: () {
          _launchURL(file.url);
        },
        child: Text('Download'),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Handle the case when the URL cannot be launched
      // For example, show an error message
    }
  }
}
