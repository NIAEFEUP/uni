import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_units/course_unit_file.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseUnitFilesRow extends StatelessWidget {
  const CourseUnitFilesRow(this.file, {Key? key}) : super(key: key);

  final CourseUnitFile file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                file.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _launchURL(file.url),
          ),
        ],
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
