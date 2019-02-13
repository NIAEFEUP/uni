import 'package:flutter/material.dart';
import '../../view/Theme.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final usernameFocus = FocusNode();
final passwordFocus = FocusNode();

class LoginPageView extends StatelessWidget {
  LoginPageView({Key key,
    @required this.saveData,
    @required this.saveDataChanged,
    @required this.logInPressed}) : super(key: key);

  final bool saveData;
  final Function saveDataChanged;
  final Function logInPressed;

  @override
  Widget build(BuildContext context) {

    final title = Text(
      "APP\nFEUP",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white, 
        fontSize: 50.0,
        fontWeight: FontWeight.w400
        ),
    );

    final username = TextFormField(
      style: new TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
      autofocus: true,
      controller: usernameController,
      focusNode: usernameFocus,
      onFieldSubmitted: (term){
        usernameFocus.unfocus();
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new UnderlineInputBorder()
      ),
    );

    final password = TextFormField(
      style: new TextStyle(color: Colors.white),
      autofocus: false,
      controller: passwordController,
      focusNode: passwordFocus,
      onFieldSubmitted: (term){
        passwordFocus.unfocus();
        logInPressed(usernameController.text, passwordController.text);
      },
      textInputAction: TextInputAction.done,
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new UnderlineInputBorder()
      ),
    );

    final save = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Guardar dados",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, 
            fontSize: 13.0,
            fontWeight: FontWeight.w300
            )
        ),
        Checkbox(value: saveData, onChanged: saveDataChanged)
      ],
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () {
          logInPressed(usernameController.text, passwordController.text);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Log In', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w400)),
      ),
    );

    final notesLabel = FlatButton(
      child: Text(
        'Notas sobre login',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
      ),
      onPressed: () {
        //TODO: what will happen when we presse this?
      },
    );

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            title,
            SizedBox(height: 100.0),
            username,
            SizedBox(height: 20.0),
            password,
            SizedBox(height: 40.0),
            save,
            SizedBox(height: 40.0),
            loginButton,
            SizedBox(height: 24.0),
            notesLabel
          ],
        ),
      ),
    );
  }
}