import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../../view/Theme.dart';

import '../widgets/NavigationDrawer.dart';

class ProfilePageView extends StatelessWidget {

  ProfilePageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("App FEUP")),
      drawer: new NavigationDrawer(),
      body: createScrollableProfileView(context)
    );
  }

  Widget createScrollableProfileView(BuildContext context){
    return new ListView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        profileInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        courseInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        printsInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        accountInfo(context)
      ]
    );
  }

  Widget profileInfo (BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
                borderRadius: BorderRadius.all(Radius.circular(90.0))),
          child: Image(
            image: AssetImage('assets/images/ni_logo.png'),
            width: 200,
            height: 200,
          ),
        ),
        Text(
          "Nome Mais Um Nome Apelido Muito Grande Mesmo",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyTextColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w400
          )
        ),
        Padding(padding: const EdgeInsets.all(5.0)),
        Text(
          "up201601234@fe.up.pt",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w200
          )
        ),
      ],
    );
  }

  Widget courseInfo (BuildContext context){
    return new GenericCard(
      title: "Mestrado Integrado em Engenharia Informática e Computação", 
      //child: new ExamCard()
    );
  }

  Widget printsInfo (BuildContext context){
    return new GenericCard(
      title: "Impressões", 
      //child: new ExamCard()
    );
  }

  Widget accountInfo (BuildContext context){
    return new GenericCard(
      title: "Conta Corrente", 
      //child: new ExamCard()
    );
  }

}