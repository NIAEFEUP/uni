import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BugReportFormState();
  }
}

class BugReportFormState extends State<BugReportForm> {

  static final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> bugList = [];
  int _selectedBug = 0;

  @override
  Widget build(BuildContext context) {
    loadBugClassList();

    return new Form(
      key: _formKey,
      child: new ListView(
          children: getFormWidget(context)
      )
    );
  }


  void loadBugClassList() {
    bugList = [];
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 1'),
      value: 0,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 2'),
      value: 1,
    ));
    bugList.add(new DropdownMenuItem(
      child: new Text('Bug 3'),
      value: 2,
    ));
  }

  List<Widget> getFormWidget(BuildContext context) {
    List<Widget> formWidget = new List();

    formWidget.add(DropdownBugSelectWidget(context));
    formWidget.add(BugDescriptionWidget(context));

    return formWidget;
  }

  Widget DropdownBugSelectWidget(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 50),
      child: new Column(
        children: <Widget>[
          new Text(
            'Seleciona o tipo de bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new DropdownButton(
            hint: new Text('Seleciona o tipo de bug'),
            items: bugList,
            value: _selectedBug,
            onChanged: (value) {
              setState(() {
                _selectedBug = value;
              });
            },
            isExpanded: true,
          )
        ],
      ),

    );
  }

  Widget BugDescriptionWidget(BuildContext context) {
    return new Container(
      //margin: EdgeInsets.all(0),
      child: new Column(
        children: <Widget>[
          new Text(
            'Descreve o bug',
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new TextFormField(
            // margins
            minLines: 6,
            maxLines: 30,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              hintText: 'What do people call you?',
              labelText: 'Descrição',
            ),
            validator: (value) {
              // TODO filter stuff to prevent attacks?
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          )
        ],
      ),

    );
  }

}