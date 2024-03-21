import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HorizontalWidget extends StatelessWidget {
  const HorizontalWidget({
    required this.ListOfWidgets,
    required this.title,
    super.key,
  });
  final List<Widget> ListOfWidgets;
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
      children: ListOfWidgets,
    ),)
  );
}

void main() {
  // Set up the necessary dependencies and variables
  List<Widget> widgets = [
    Container(child: Row(children: [Text('Container 1')],),
      height: 200,
      width:100),
    const Text('Container 2'),
    const Text('Container 3'),];
  HorizontalWidget horizontalWidget = HorizontalWidget(
    ListOfWidgets: widgets,
    title: 'Queijo',
    );

  setUp(() {
    widgets = [
      Container(child: Text('Container 1')),
      const Text('Container 2'),
      const Text('Container 3'),
    ];
    horizontalWidget = HorizontalWidget(
      ListOfWidgets: widgets,
      title: 'Horizontal Widget Test',
    );
  });

  testWidgets('HorizontalWidget displays correct title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: horizontalWidget,
        ),
      ),
    );

    // Assert that the title is displayed correctly
    expect(find.text('Horizontal Widget Test'), findsOneWidget);
  });

  testWidgets('HorizontalWidget displays correct number of widgets', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: horizontalWidget,
        ),
      ),
    );

    // Assert that the correct number of widgets is displayed
    expect(find.byType(Text), findsNWidgets(widgets.length));
  });

  // Add more test cases as needed

}