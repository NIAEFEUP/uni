import 'package:flutter/material.dart';
import 'package:uni_ui/timeline/timeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
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
