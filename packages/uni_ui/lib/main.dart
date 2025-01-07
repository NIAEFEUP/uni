/*
import 'package:flutter/material.dart';
import 'package:uni_ui/theme.dart';
import 'package:uni_ui/timeline/timeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Timeline Example'),
        ),
        body: Timeline(
          content: [
            Container(
              color: Colors.red[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 1',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Suspendisse eget tincidunt sapien. Phasellus sed ligula id '
                        'turpis vulputate efficitur. Donec ut arcu vel leo blandit '
                        'dictum. Cras ut massa nisi. Nulla facilisi. Quisque porta '
                        'lobortis diam, at interdum orci.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                        'accusantium doloremque laudantium, totam rem aperiam, eaque '
                        'ipsa quae ab illo inventore veritatis et quasi architecto '
                        'beatae vitae dicta sunt explicabo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'At vero eos et accusamus et iusto odio dignissimos ducimus '
                        'qui blanditiis praesentium voluptatum deleniti atque corrupti '
                        'quos dolores et quas molestias excepturi sint occaecati '
                        'cupiditate non provident.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 2',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut '
                        'odit aut fugit, sed quia consequuntur magni dolores eos qui '
                        'ratione voluptatem sequi nesciunt.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, '
                        'consectetur, adipisci velit, sed quia non numquam eius modi '
                        'tempora incidunt ut labore et dolore magnam aliquam quaerat '
                        'voluptatem.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ut enim ad minima veniam, quis nostrum exercitationem ullam '
                        'corporis suscipit laboriosam, nisi ut aliquid ex ea commodi '
                        'consequatur?',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 3',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quis autem vel eum iure reprehenderit qui in ea voluptate '
                        'velit esse quam nihil molestiae consequatur, vel illum qui '
                        'dolorem eum fugiat quo voluptas nulla pariatur?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'But I must explain to you how all this mistaken idea of '
                        'denouncing pleasure and praising pain was born and I will '
                        'give you a complete account of the system, and expound the '
                        'actual teachings of the great explorer of the truth.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nor again is there anyone who loves or pursues or desires to '
                        'obtain pain of itself, because it is pain, but because '
                        'occasionally circumstances occur in which toil and pain can '
                        'procure him some great pleasure.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 4',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Suspendisse eget tincidunt sapien. Phasellus sed ligula id '
                        'turpis vulputate efficitur. Donec ut arcu vel leo blandit '
                        'dictum. Cras ut massa nisi. Nulla facilisi. Quisque porta '
                        'lobortis diam, at interdum orci.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                        'accusantium doloremque laudantium, totam rem aperiam, eaque '
                        'ipsa quae ab illo inventore veritatis et quasi architecto '
                        'beatae vitae dicta sunt explicabo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'At vero eos et accusamus et iusto odio dignissimos ducimus '
                        'qui blanditiis praesentium voluptatum deleniti atque corrupti '
                        'quos dolores et quas molestias excepturi sint occaecati '
                        'cupiditate non provident.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 5',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Suspendisse eget tincidunt sapien. Phasellus sed ligula id '
                        'turpis vulputate efficitur. Donec ut arcu vel leo blandit '
                        'dictum. Cras ut massa nisi. Nulla facilisi. Quisque porta '
                        'lobortis diam, at interdum orci.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                        'accusantium doloremque laudantium, totam rem aperiam, eaque '
                        'ipsa quae ab illo inventore veritatis et quasi architecto '
                        'beatae vitae dicta sunt explicabo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'At vero eos et accusamus et iusto odio dignissimos ducimus '
                        'qui blanditiis praesentium voluptatum deleniti atque corrupti '
                        'quos dolores et quas molestias excepturi sint occaecati '
                        'cupiditate non provident.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 6',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Suspendisse eget tincidunt sapien. Phasellus sed ligula id '
                        'turpis vulputate efficitur. Donec ut arcu vel leo blandit '
                        'dictum. Cras ut massa nisi. Nulla facilisi. Quisque porta '
                        'lobortis diam, at interdum orci.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                        'accusantium doloremque laudantium, totam rem aperiam, eaque '
                        'ipsa quae ab illo inventore veritatis et quasi architecto '
                        'beatae vitae dicta sunt explicabo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'At vero eos et accusamus et iusto odio dignissimos ducimus '
                        'qui blanditiis praesentium voluptatum deleniti atque corrupti '
                        'quos dolores et quas molestias excepturi sint occaecati '
                        'cupiditate non provident.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content for Tab 7',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Suspendisse eget tincidunt sapien. Phasellus sed ligula id '
                        'turpis vulputate efficitur. Donec ut arcu vel leo blandit '
                        'dictum. Cras ut massa nisi. Nulla facilisi. Quisque porta '
                        'lobortis diam, at interdum orci.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                        'accusantium doloremque laudantium, totam rem aperiam, eaque '
                        'ipsa quae ab illo inventore veritatis et quasi architecto '
                        'beatae vitae dicta sunt explicabo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'At vero eos et accusamus et iusto odio dignissimos ducimus '
                        'qui blanditiis praesentium voluptatum deleniti atque corrupti '
                        'quos dolores et quas molestias excepturi sint occaecati '
                        'cupiditate non provident.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
          tabs: [
            Column(
              children: [
                Text('Mon'),
                Text('1'),
              ],
            ),
            Column(
              children: [
                Text('Tue'),
                Text('2'),
              ],
            ),
            Column(
              children: [
                Text('Wed'),
                Text('3'),
              ],
            ),
            Column(
              children: [
                Text('Thu'),
                Text('4'),
              ],
            ),
            Column(
              children: [
                Text('Fri'),
                Text('5'),
              ],
            ),
            Column(
              children: [
                Text('Sat'),
                Text('6'),
              ],
            ),
            Column(
              children: [
                Text('Sun'),
                Text('7'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/enrollment_info.dart';
import 'package:uni_ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Timeline Example'),
            ),
            body: ModalDialog(children: [
              ModalEnrollementInfo(enrollements: {'SO': 'test'},)
            ],)
        )
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:uni_ui/cards/course_grade_card.dart';
import 'package:uni_ui/cards/service_card.dart';
import 'package:uni_ui/theme.dart';

import 'cards/exam_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Timeline Example'),
          ),
          body: ListView(
            children: [
              ExamCard(name: "LCOM", acronym: "LCOM", rooms: ["1","3","4"], type: "ER"),
              ServiceCard(name: 'test', openingHours: ["09:00-12:00","14:00-17:00"],),
              CourseGradeCard(courseName: "LCOM", ects: 36, grade: 12),
            ],
          )
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/enrollment_info.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';
import 'package:uni_ui/modal/widgets/person_info.dart';
import 'package:uni_ui/modal/widgets/service_info.dart';
import 'package:uni_ui/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Flutter code sample for [Dialog].

void main() => runApp(const DialogExampleApp());

class DialogExampleApp extends StatelessWidget {
  const DialogExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Dialog Sample')),
        body: const Center(
          child: DialogExample(),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('This is a typical dialog.'),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: const Text('Show Dialog'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => ModalDialog(children: [
                    ModalServiceInfo(
                        name: "Dona Beatriz",
                        durations: ["09:30-12:30", "14:30-17:30"]),
/*
              ModalPersonInfo(name: "Pedro Souto"),
*/
                    ModalInfoRow(
                        title: "title",
                        description: "description",
                        icon: PhosphorIcons.clock()),
                    ModalInfoRow(
                        title: "title",
                        description: "description",
                        icon: PhosphorIcons.clock()),
                    ModalInfoRow(
                        title: "title",
                        description: "description",
                        icon: PhosphorIcons.clock()),
                  ])),
          child: const Text('Show Fullscreen Dialog'),
        ),
      ],
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:uni_ui/cards/library_occupation_card.dart';
import 'package:uni_ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final Map<String, dynamic> occupationMap;

  MyApp() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Library Occupation Card Example'),
          ),
          body: ListView(
            children: [
              LibraryOccupationCard(
                capacity: 300,
                occupation: 200,
                occupationCardsList: [
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 10,
                    floorText: "Floor",
                    floorNumber: 1,
                  ),
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 20,
                    floorText: "Floor",
                    floorNumber: 2,
                  ),
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 25,
                    floorText: "Floor",
                    floorNumber: 3,
                  ),
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 40,
                    floorText: "Floor",
                    floorNumber: 4,
                  ),
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 45,
                    floorText: "Floor",
                    floorNumber: 5,
                  ),
                  FloorOccupationWidget(
                    capacity: 50,
                    occupation: 50,
                    floorText: "Floor",
                    floorNumber: 6,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
