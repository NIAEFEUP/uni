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
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 100.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: createTitle(),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    createUsernameInput(context),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    createPasswordInput(),
                    Padding(padding: EdgeInsets.only(bottom: 5)),
                    createSaveDataCheckBox()
                  ]
                )
              ),
              createLogInButton(),
              Padding(padding: EdgeInsets.only(bottom: 50)),
              Expanded(
                flex: 1,
                child: createNoteLabel(),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget createTitle(){
    return Text(
      "APP\nFEUP",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white, 
        fontSize: 50.0,
        fontWeight: FontWeight.w400
        ),
    );
  }

  Widget createUsernameInput(BuildContext context){
    return TextFormField(
      style: new TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
      autofocus: false,
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
  }

  Widget createPasswordInput(){
    return TextFormField(
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
  }

  Widget createSaveDataCheckBox(){
    return Row(
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
  }

  Widget createLogInButton(){
    return new SizedBox(
        width: 150,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onPressed: () {
            logInPressed(usernameController.text, passwordController.text);
          },
          padding: EdgeInsets.all(12),
          color: Colors.white,
          child: Text('Log In', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w400, fontSize: 18), textAlign: TextAlign.center),
        ),
    );
  }

  //TODO: probably a "Forgot my password" link
  Widget createNoteLabel(){
    return FlatButton(
      child: Text(
        ' ', //no text for now
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
      ),
      onPressed: () {
        //TODO: redirect to sigarra page maybe
      },
    );
  }
}